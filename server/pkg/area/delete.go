package area

import (
	"net/http"
	"strconv"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

func (h areaHandler) DeleteArea(c *gin.Context) {

	area := models.Area{}
	id, err := strconv.ParseUint(c.Param("area_id"), 0, 64)
	if err != nil {
		c.AbortWithStatus(http.StatusNotFound)
	}

	area.ID = uint(id)

	if result := h.DB.Unscoped().Delete(&area); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
		return
	}

	c.Status(http.StatusAccepted)
}
