package certificate

import (
	"net/http"

	"github.com/ashwincreates/svas/pkg/common/models"
	"github.com/gin-gonic/gin"
)

type CertificateJson struct {
	VendorId      uint   `json:"vendorId"`
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
}

func (h certificateHandler) CreateCertificate(c *gin.Context) {
	body := CertificateJson{}

	if err := c.BindJSON(&body); err != nil {
		c.AbortWithError(http.StatusBadRequest, err)
		return
	}

	var certificate models.Certificate

	if result := h.DB.First(&certificate, "vendor_id = ?", body.VendorId); result.Error == nil {
		c.AbortWithStatus(http.StatusConflict)
		return
	}

	certificate = models.Certificate{
		VendorId:      body.VendorId,
		FirstName:     body.FirstName,
		MiddleName:    body.MiddleName,
		LastName:      body.LastName,
		Address:       body.Address,
		DocType:       body.DocType,
		DocId:         body.DocId,
		Nominee1:      body.Nominee1,
		Nominee2:      body.Nominee2,
		BussinessName: body.BussinessName,
		BussinessType: body.BussinessType,
	}

	if result := h.DB.Create(&certificate); result.Error != nil {
		c.AbortWithError(http.StatusNotFound, result.Error)
		return
	}

	c.JSON(http.StatusAccepted, struct {
		Id     uint
		Status string
	}{
		Id:     certificate.ID,
		Status: certificate.Status,
	})
}
