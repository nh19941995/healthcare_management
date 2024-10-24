package org.example.healthcare_management.services;

import org.example.healthcare_management.controllers.dto.BookingDto;
import org.example.healthcare_management.controllers.dto.ClinicDto;
import org.example.healthcare_management.entities.Booking;
import org.example.healthcare_management.entities.Clinic;

import java.util.Set;

public interface BookingService {
    Booking convertToEntity(BookingDto bookingDto);
    BookingDto convertToDTO(Booking booking);
    Set<BookingDto> convertToDTOs(Set<Booking> bookings);
    Set<Booking> convertToEntities(Set<BookingDto> bookingDtos);
}
