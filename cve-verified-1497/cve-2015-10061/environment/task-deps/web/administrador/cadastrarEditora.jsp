<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Cadastro de Categoria</title>

        <!-- Bootstrap -->
        <link href="../css/bootstrap.min.css" rel="stylesheet">

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
    </head>
    <body>
        <!--Inclui cabeçalho-->
        <jsp:include page="navAdministrador.jsp"/>
        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <p class="lead">Magazine Store</p>
                    <div class="list-group">
                        <a href="buscarCliente.jsp" class="list-group-item">Buscar Cliente</a>
                        <a href="cadastrarProduto.jsp" class="list-group-item">Cadastrar Produto</a>
                        <a href="cadastrarCategoria.jsp" class="list-group-item">Cadastrar Categoria</a>
                        <a href="cadastrarEditora.jsp" class="list-group-item">Cadastrar Editora</a>
                    </div>
                </div>
                <div class="col-md-9 ">
                    <h1>Cadastro de Editoras</h1>
                    <form class="form-horizontal" method="POST" action="./Editoras?action=cadastrar">
                        <div class="form-group">
                            <label for="" class="col-sm-2 control-label">Nome</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="editora" name="editora" placeholder="" required />
                            </div>
                        </div>   
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-6">
                                <button type="submit" class="btn btn-success btn-lg btn-block ">Cadastrar</button>
                            </div>
                        </div>
                    </form>
                     <hr />
                    <table class="table">
                        <tr>
                            <th>#</th>
                            <th>Título</th>
                            <th>Editar</th>
                            <th>Remover</th>
                        </tr>
                        <!-- inserir via banco de dados -->
                        <c:forEach items="${editoraLista}" var="editora">
                            <tr>
                                <td>${editora.idEditora}</td>
                                <td>${editora.nome}</td>
                                <td><a href="" data-toggle="modal" data-target="#exampleModal" data-ideditora="${editora.idEditora}" data-editora="${editora.nome}"><span class="glyphicon glyphicon-pencil"></span></a></td>
                                <td><a href="Editoras?action=remover&id=${editora.idEditora}"><span class="glyphicon glyphicon-trash"></span></a></td>

                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </div>
        <div class="modal fade" id="exampleModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="exampleModalLabel">Editar Editora</h4>
                    </div>
                    <div class="modal-body">
                        <form action="Editoras?action=editar" method="post">
                            <div class="form-group">
                                <input type="hidden" class="form-control" id="editora-id" name="editora-id"></textarea>
                            </div>                            
                            <div class="form-group">
                                <label for="genero-nome" class="control-label">Editora:</label>
                                <input type="text" class="form-control" id="editora-nome" name="editora-nome">
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-default" data-dismiss="modal">Fechar</button>
                                <button type="submit" class="btn btn-primary">Editar</button>
                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </div>
        
        
        <!--Inclui Rodapé-->
        <jsp:include page="../comum/rodape.jsp"/>

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
        
        <script>
            $(function () {

                $('#exampleModal').on('show.bs.modal', function (event) {
                    var button = $(event.relatedTarget); // Button that triggered the modal
                    var ideditora = button.data('ideditora'); // Extract info from data-* attributes
                    var editora = button.data('editora');
                    var modal = $(this);
                    modal.find('#editora-id').val(ideditora);
                    modal.find('#editora-nome').val(editora);
                })
            });

        </script>        
        
        
        
    </body>
</html>