package area

import (
	"net/http"
	"strconv"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

func (h areaHandler) UpdateArea(c *gin.Context) {
	body := AreaJson{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var area models.Area

	area = models.Area {
		Name: body.Name,
		Address: body.Address,
		Longitude: body.Longitude,
		Latitude: body.Latitude,
		Radius: body.Radius,
		Limit: body.Limit,
		City: body.City,
	}

	id, _ := strconv.ParseUint(c.Param("area_id"), 0, 64)
	area.ID = uint(id)

	if result := h.DB.Save(&area); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
		return
	}

	c.Status(http.StatusAccepted)
}
