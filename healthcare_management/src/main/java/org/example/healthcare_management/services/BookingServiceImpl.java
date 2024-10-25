package org.example.healthcare_management.services;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.controllers.dto.BookingDto;
import org.example.healthcare_management.entities.Booking;
import org.example.healthcare_management.repositories.BookingRepo;
import org.modelmapper.ModelMapper;
import org.springframework.stereotype.Service;

import java.util.Set;
import java.util.stream.Collectors;

@Service
@AllArgsConstructor
public class BookingServiceImpl implements BookingService {
    private final ModelMapper modelMapper;
    private final BookingRepo bookingRepository;

    @Override
    public Booking convertToEntity(BookingDto bookingDto) {
        return modelMapper.map(bookingDto, Booking.class);
    }

    @Override
    public BookingDto convertToDTO(Booking booking) {
        return modelMapper.map(booking, BookingDto.class);
    }

    @Override
    public Set<BookingDto> convertToDTOs(Set<Booking> bookings) {
        return bookings.stream()
                .map(this::convertToDTO)
                .collect(Collectors.toSet());
    }

    @Override
    public Set<Booking> convertToEntities(Set<BookingDto> bookingDtos) {
        return bookingDtos.stream()
                .map(this::convertToEntity)
                .collect(Collectors.toSet());
    }
}
