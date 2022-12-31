package license

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

func (h *licenseHandler) RetrieveLicense(c *gin.Context) {
	var licenses []struct {
		Id        uint
		AreaId    uint
		Name      string
		Address   string
		ValidTill time.Time
		Longitude float64
		Latitude  float64
		Radius    uint
	}

	result := h.DB.Raw("SELECT licenses.id, area_id, name, address, valid_till, longitude, latitude, radius FROM licenses JOIN areas  ON licenses.area_id = areas.id AND licenses.vendor_id = ?", c.Param("vendor_id")).Scan(&licenses)
	if result.Error != nil {
		c.AbortWithStatus(http.StatusBadRequest)
	}

	c.JSON(http.StatusOK, licenses)
}
