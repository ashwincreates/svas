package area

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type areaHandler struct {
	DB *gorm.DB
}

func RegisterRoutes(c *gin.Engine, db *gorm.DB) {
	h := &areaHandler {
		DB: db,
	}

	routes := c.Group("/api/area")
	routes.POST("/create", h.CreateArea)
	routes.POST("/delete/:area_id", h.DeleteArea)
	routes.POST("/update/:area_id", h.UpdateArea)
	routes.GET("/get/:city", h.GetArea)
}
