package com.api.exemploflutter.services;

import com.api.exemploflutter.dtos.RequestRecordDTO;
import com.api.exemploflutter.dtos.ResponseRecordDTO;
import com.api.exemploflutter.entity.Usuario;
import com.api.exemploflutter.repository.UsuarioRepository;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class UsuarioServices {

    private final UsuarioRepository usuarioRepository;

    public UsuarioServices(UsuarioRepository usuarioRepository) {
        this.usuarioRepository = usuarioRepository;
    }

    public ResponseEntity<List<ResponseRecordDTO>> readAll() {
        List<ResponseRecordDTO> listaUsuario = usuarioRepository
                .findAll()
                .stream()
                .map(ResponseRecordDTO::new)
                .toList();

        return ResponseEntity.status(HttpStatus.OK).body(listaUsuario);
    }

    public ResponseEntity<Usuario> create(RequestRecordDTO data) {
        var novoUsuario = new Usuario(data);
        usuarioRepository.save(novoUsuario);
        return ResponseEntity.status(HttpStatus.CREATED).body(novoUsuario);
    }
}
