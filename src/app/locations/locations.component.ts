import { Component, OnInit } from '@angular/core';
import { Area, AreaService } from '../services/area.service';

@Component({
	selector: 'app-locations',
	templateUrl: './locations.component.html',
	styleUrls: ['./locations.component.scss']
})
export class LocationsComponent implements OnInit {

	defaultCenter: google.maps.LatLngLiteral = { lat: 23.1815, lng: 79.9864 };

	editEnabled = false;
	infoEnabled = false;

	selectedArea: Area | null = null;

	mapOptions: google.maps.MapOptions = {
		fullscreenControl: false,
		rotateControl: false,
	}
	markerOptions: google.maps.MarkerOptions = { draggable: false };
	circleOptions: google.maps.CircleOptions = { fillColor: "#64b5f6", strokeColor: "#1976d2"}

	markerPositions: Area[] = [];

	constructor(private areaService: AreaService) { }

	ngOnInit(): void {
		// Get areas from the server and update
		this.updateAreas();
	}

	toggleEditPanel(_event: Event) {
		if (this.editEnabled) {
			this.editEnabled = false;
			this.defaultCenter = this.selectedArea!.center
			this.selectedArea = null;
		} else {
			this.editEnabled = true;
		}
	}

	toggleInfoPanel(area: Area | null) {
		if (this.infoEnabled && !area) {
			this.infoEnabled = false
			this.defaultCenter = this.selectedArea!.center
			this.selectedArea = null
		} else {
			console.log(area)
			this.selectedArea = area
			this.infoEnabled = true
		}
	}

	changeMarker(event: google.maps.MapMouseEvent) {
		if (event.latLng && this.editEnabled) {
			this.selectedArea = {
				id: 0,
				name: "",
				address: "",
				center: event.latLng.toJSON(),
				radius: 100
			}
		}
	}

	updateName(event: KeyboardEvent) {
		if (this.selectedArea) {
			this.selectedArea.name = (event.target as HTMLInputElement).value
		}
	}

	updateAddress(event: KeyboardEvent) {
		if (this.selectedArea) {
			this.selectedArea.address = (event.target as HTMLInputElement).value
		}
	}

	updateRadius(event: KeyboardEvent) {
		let value = parseInt((event.target as HTMLInputElement).value)
		if (this.selectedArea) {
			this.selectedArea.radius = value;
		}
	}

	addMarker(_event: Event) {
		if (!this.selectedArea) return;
		this.areaService.createArea(this.selectedArea)
			.subscribe(
				result => {
					console.log(result)
				}
			).add(() => {
				this.updateAreas()
				console.log(this.markerPositions)
			})
		this.toggleEditPanel(_event)
	}

	updateMarker(_event: Event) {
		if (!this.selectedArea) return;
		this.areaService.updateArea(this.selectedArea)
			.subscribe(
				result => {
					console.log(result)
				}
			).add(() => {
				this.updateAreas()
				console.log(this.markerPositions)
			})
		this.toggleInfoPanel(null)
	}

	deleteMarker(_event: Event) {
		if(!this.selectedArea) return;
		this.areaService.deleteArea(this.selectedArea)
			.subscribe(
				result => {
					console.log(result)
				}
			).add(() => {
				this.updateAreas()
				console.log(this.markerPositions)
			})
		this.toggleInfoPanel(null)
	}

	updateAreas() {
		this.areaService.getArea()
			.subscribe(
				areas => this.markerPositions = areas.map(
					area => ({
						id: area.ID,
						name: area.Name,
						address: area.Address,
						center: {
							lat: area.Latitude,
							lng: area.Longitude,
						},
						radius: area.Radius
					} as Area)
				)
			)
	}
}
