package models

import "gorm.io/gorm"

type Certificate struct {
	gorm.Model
	FirstName     string
	MiddleName    string
	LastName      string
	Address       string
	DocType       string
	DocId         string
	Nominee1      string
	Nominee2      string
	BussinessName string
	BussinessType string
	VendorId      uint
	Status        string `gorm:"default:PENDING"`
	Vendor        Vendor
}
