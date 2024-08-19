package com.api.exemploflutter.entity;

import com.api.exemploflutter.dtos.RequestRecordDTO;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "TB_USUARIO")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(of = "id")
public class Usuario {

    @Id @GeneratedValue(strategy = GenerationType.SEQUENCE)
    private Integer id;
    private String nome;
    private String telefone;
    private String senha;

    public Usuario(RequestRecordDTO data) {
        setNome(data.nome());
        setTelefone(data.telefone());
        setSenha(data.senha());
    }

}
