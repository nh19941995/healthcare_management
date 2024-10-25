package org.example.healthcare_management.controllers;

import lombok.AllArgsConstructor;
import org.example.healthcare_management.entities.TimeSlot;
import org.example.healthcare_management.repositories.TimeSlotRepo;
import org.springframework.hateoas.CollectionModel;
import org.springframework.hateoas.EntityModel;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.stream.Collectors;

import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.linkTo;
import static org.springframework.hateoas.server.mvc.WebMvcLinkBuilder.methodOn;

@RestController
@AllArgsConstructor
public class TimeSlotController {
    private final TimeSlotRepo timeSlotRepo;

    @GetMapping("/timeslots")
    public CollectionModel<EntityModel<TimeSlot>> getTimeSlots() {
        List<TimeSlot> timeSlots = timeSlotRepo.findAll();

        List<EntityModel<TimeSlot>> timeSlotModels = timeSlots.stream()
                .map(timeSlot -> EntityModel.of(timeSlot,
                        linkTo(methodOn(TimeSlotController.class).getTimeSlot(timeSlot.getId())).withSelfRel(),
                        linkTo(methodOn(TimeSlotController.class).getTimeSlots()).withRel("timeSlots")))
                .collect(Collectors.toList());

        return CollectionModel.of(timeSlotModels,
                linkTo(methodOn(TimeSlotController.class).getTimeSlots()).withSelfRel());
    }

    // Thêm phương thức để lấy một TimeSlot cụ thể
    @GetMapping("/timeslots/{id}")
    public EntityModel<TimeSlot> getTimeSlot(@PathVariable Long id) {
        TimeSlot timeSlot = timeSlotRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("TimeSlot not found"));

        return EntityModel.of(timeSlot,
                linkTo(methodOn(TimeSlotController.class).getTimeSlot(id)).withSelfRel(),
                linkTo(methodOn(TimeSlotController.class).getTimeSlots()).withRel("timeSlots"));
    }


}
