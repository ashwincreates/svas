import { Component } from '@angular/core';

@Component({
    selector: 'app-dashboard',
    templateUrl: './dashboard.component.html',
    styleUrls: ['./dashboard.component.scss']
})
export class DashboardComponent {

    sidebarVisible: boolean = true;

    constructor() { }

    toggleVisible() {
        this.sidebarVisible = !this.sidebarVisible;
    }

}
