class Book {
final int? id;
final String titulo;
final String autor;
final int ano;
final String genero;
final int paginas;


Book({
this.id,
required this.titulo,
required this.autor,
required this.ano,
required this.genero,
required this.paginas,
});


Book copyWith({int? id, String? titulo, String? autor, int? ano, String? genero, int? paginas}) {
return Book(
id: id ?? this.id,
titulo: titulo ?? this.titulo,
autor: autor ?? this.autor,
ano: ano ?? this.ano,
genero: genero ?? this.genero,
paginas: paginas ?? this.paginas,
);
}


Map<String, dynamic> toMap() => {
'id': id,
'titulo': titulo,
'autor': autor,
'ano': ano,
'genero': genero,
'paginas': paginas,
};


factory Book.fromMap(Map<String, dynamic> map) => Book(
id: map['id'] as int?,
titulo: map['titulo'] as String,
autor: map['autor'] as String,
ano: (map['ano'] as num).toInt(),
genero: map['genero'] as String,
paginas: (map['paginas'] as num).toInt(),
);
}