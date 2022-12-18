package certificate

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

func (h certificateHandler) RetrieveCertificate(c *gin.Context) {

	var certificate models.Certificate

	if result := h.DB.First(&certificate, "vendor_id = ?", c.Param("vendor_id")); result.Error != nil {
		c.AbortWithStatus(http.StatusNotFound)
		return
	}

	c.JSON(http.StatusAccepted, struct {
		Id            uint   `json:"id"`
		FirstName     string `json:"firstName"`
		MiddleName    string `json:"middleName"`
		LastName      string `json:"lastName"`
		Address       string `json:"address"`
		DocType       string `json:"docType"`
		DocId         string `json:"docId"`
		Nominee1      string `json:"nominee1"`
		Nominee2      string `json:"nominee2"`
		BussinessName string `json:"bussinessName"`
		BussinessType string `json:"bussinessType"`
	}{
		certificate.ID,
		certificate.FirstName,
		certificate.MiddleName,
		certificate.LastName,
		certificate.Address,
		certificate.DocType,
		certificate.DocId,
		certificate.Nominee1,
		certificate.Nominee2,
		certificate.BussinessName,
		certificate.BussinessType,
	})
}
