package license

import (
	"net/http"
	"strconv"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

// Activates license with the given 'id' if the area assigned has slots to
// accomodate this vendor i.e summation of licenses in area < area.limit
func (h licenseHandler) ActivateLicense(c *gin.Context) {
	licId, _ := strconv.ParseUint(c.Param("license_id"), 0, 64)	

	var license models.License

	if result := h.DB.First(&license, "id = ?", licId); result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	result := h.DB.Raw("SELECT areas.id, T.count FROM areas INNER JOIN (SELECT licenses.area_id, COUNT(vendors.id) as count FROM vendors INNER JOIN licenses WHERE vendors.id = licenses.vendor_id  GROUP BY licenses.area_id) as T where areas.id = T.area_id AND areas.id = ? AND T.count < areas.limit;", license.AreaID)

	if result.Error != nil {
		c.AbortWithStatus(http.StatusConflict)
		return
	}

	vendor := license.Vendor
	vendor.LicenseId = license.ID

	h.DB.Save(&license)
	h.DB.Save(&vendor)

	c.Status(http.StatusAccepted)
}
