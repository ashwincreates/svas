## Svas
A Street Vendor Management System for managing streets vendors across the city
This includes a admin side and client app along with a backend.

### Admin
The admin side is created in angular. To start the project run the following command:
```
	ng start --proxy-config .\proxy.config.json
```

Various constants can be found in .env

# Client
The client side is a flutter app and resides in /app folder. If using emulator
make sure playstore is installed.

Key for map is added in main/AndroidManifest.xml

# Backend
The Backend is created using golang/gin with mysql as database. Make sure to 
follow the file structure.

Various constants can be found in .env


