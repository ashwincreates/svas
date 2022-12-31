package area

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

func (h *areaHandler) GetArea(c *gin.Context) {
	city := c.Param("city")

	var area []models.Area

	result := h.DB.Find(&area, "city = ?", city)
	if result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	c.JSON(http.StatusAccepted, area)
}
