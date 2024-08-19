package com.api.exemploflutter.controllers;

import com.api.exemploflutter.dtos.RequestRecordDTO;
import com.api.exemploflutter.dtos.ResponseRecordDTO;
import com.api.exemploflutter.entity.Usuario;
import com.api.exemploflutter.services.UsuarioServices;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuario")
public class UsuarioController {

    private final UsuarioServices usuarioServices;

    public UsuarioController(UsuarioServices usuarioServices) {
        this.usuarioServices = usuarioServices;
    }

    @GetMapping
    public ResponseEntity<List<ResponseRecordDTO>> readAll() {
        return usuarioServices.readAll();
    }

    @PostMapping
    public ResponseEntity<Usuario> create(@RequestBody @Validated RequestRecordDTO data) {
        return usuarioServices.create(data);
    }
}
