package com.api.exemploflutter.dtos;

import com.api.exemploflutter.entity.Usuario;

public record ResponseRecordDTO(Integer id, String nome, String telefone, String senha) {

    public ResponseRecordDTO(Usuario data) {
        this(data.getId(), data.getNome(), data.getTelefone(), data.getSenha());
    }
}
