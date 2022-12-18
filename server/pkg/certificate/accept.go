package certificate

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

func (h certificateHandler) AcceptCertificate(c *gin.Context) {

	var certificate models.Certificate

	if result := h.DB.First(&certificate, "vendor_id = ?", c.Param("vendor_id")).Update("status", "ACCEPTED"); result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	c.Status(http.StatusAccepted)
}
