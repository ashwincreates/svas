package models

import (
	"gorm.io/gorm"
)

type Vendor struct {
	gorm.Model
	Email        string
	Name         string
	Password     string
	SessionToken string
	LicenseId    uint
	CertificateID  uint
}
