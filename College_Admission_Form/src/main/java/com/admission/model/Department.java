package com.admission.model;

public class Department {
    private int id;
    private String name, code, hodName, description;
    private int totalSeats, availableSeats;
    private boolean active;

    public int getId() { return id; } public void setId(int id) { this.id = id; }
    public String getName() { return name; } public void setName(String n) { this.name = n; }
    public String getCode() { return code; } public void setCode(String c) { this.code = c; }
    public String getHodName() { return hodName; } public void setHodName(String h) { this.hodName = h; }
    public String getDescription() { return description; } public void setDescription(String d) { this.description = d; }
    public int getTotalSeats() { return totalSeats; } public void setTotalSeats(int t) { this.totalSeats = t; }
    public int getAvailableSeats() { return availableSeats; } public void setAvailableSeats(int a) { this.availableSeats = a; }
    public boolean isActive() { return active; } public void setActive(boolean a) { this.active = a; }
    public int getFilledSeats() { return totalSeats - availableSeats; }
    public double getOccupancyPercent() { return totalSeats == 0 ? 0 : (getFilledSeats() * 100.0) / totalSeats; }
}
