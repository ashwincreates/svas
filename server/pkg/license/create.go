package license

import (
	"net/http"
	"time"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/ashwincreates/svas/pkg/common/util"
	"github.com/gin-gonic/gin"
)

type LicenseJson struct {
	VendorId  uint `json:"vendor_id"`
	AreaId    uint `json:"area_id"`
	ValidTill uint `json:"valid_till"`
}

func (h licenseHandler) CreateLicense(c *gin.Context) {
	body := LicenseJson{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var license models.License

	existingLicense := h.DB.Where("vendor_id = ? AND area_id = ?", body.VendorId, body.AreaId, true).First(&license)

	if existingLicense.Error == nil {
		c.AbortWithStatus(http.StatusConflict)
	}

	license.VendorID = body.VendorId
	license.AreaID = body.AreaId
	license.ValidTill = util.ValidTillDate(time.Now(), body.ValidTill)

	if result := h.DB.Create(&license); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
	}

	vendor := license.Vendor
	vendor.LicenseId = license.ID

	if result := h.DB.Save(&vendor); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
	}

	c.Status(http.StatusOK)
}
