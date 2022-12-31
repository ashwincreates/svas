package area

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

type AreaJson struct {
	Name      string  `json:"name"`
	Address   string  `json:"address"`
	Longitude float64 `json:"long"`
	Latitude  float64 `json:"lat"`
	Radius    uint    `json:"radius"`
	Limit     uint    `json:"limit"`
	City      string  `city:"city"`
}

func (h areaHandler) CreateArea(c *gin.Context) {
	body := AreaJson{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var area models.Area

	area = models.Area{
		Name:      body.Name,
		Address:   body.Address,
		Longitude: body.Longitude,
		Latitude:  body.Latitude,
		Radius:    body.Radius,
		Limit:     body.Limit,
		City:      body.City,
	}

	if result := h.DB.Create(&area); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
		return
	}

	c.Status(http.StatusAccepted)
}
