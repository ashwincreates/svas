package certificate

import (
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
)

type certificateHandler struct {
	DB *gorm.DB
}

func RegisterRoutes (server *gin.Engine, db *gorm.DB) {
	h := &certificateHandler {
		DB: db,
	}

	routes := server.Group("/api/certificate")
	routes.POST("/create", h.CreateCertificate)
	routes.GET("/retrieve/:vendor_id", h.RetrieveCertificate)
	routes.POST("/accept/:vendor_id", h.AcceptCertificate)
	routes.POST("/reject/:vendor_id", h.RejectCertificate)
}
