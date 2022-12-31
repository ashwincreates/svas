package license

import (
	"net/http"
	"strconv"
	"time"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/ashwincreates/svas/pkg/common/util"
	"github.com/gin-gonic/gin"
)

// This deletes the old license and recreates it
func (h licenseHandler) RenewLicense(c *gin.Context) {
	var license models.License

	licId, _ := strconv.ParseUint(c.Param("license_id"), 0, 64)
	validTill, _ := strconv.ParseUint(c.Param("valid_till"), 0, 64)

	result := h.DB.First(&license, "id = ?", licId)

	if result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	h.DB.Unscoped().Delete(&license)

	var newLicense models.License

	newLicense.ValidTill = util.ValidTillDate(time.Now(), uint(validTill))
	newLicense.VendorID = license.VendorID
	newLicense.AreaID = license.AreaID

	create := h.DB.Create(&newLicense)

	if create.Error != nil {
		c.AbortWithError(http.StatusNotFound, create.Error)
		return
	}

	vendor := newLicense.Vendor
	vendor.LicenseId = newLicense.ID

	h.DB.Save(&vendor)

	c.JSON(http.StatusAccepted, struct {
		ID uint
		ValidTill time.Time
	}{
		newLicense.ID,
		newLicense.ValidTill,
	})
}
