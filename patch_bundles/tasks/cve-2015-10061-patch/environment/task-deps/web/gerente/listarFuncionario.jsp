<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Cadastro de Categoria</title>

        <!--JQuery CSS-->
        <link rel="stylesheet" href="../js/jquery-ui.css">

        <!-- Bootstrap -->
        <link href="../css/bootstrap.min.css" rel="stylesheet">

        <!-- Custom CSS -->
        <link href="../css/shop-homepage.css" rel="stylesheet">

        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <script src="../js/jquery-ui.js"></script>

        <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
        <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
        <!--[if lt IE 9]>
          <script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
          <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
        <![endif]-->
        <script>

            $(function () {

                var start = new Date();
                start.setFullYear(start.getFullYear() - 100);
                var end = new Date();
                end.setFullYear(end.getFullYear() - 13);

                $('#datepicker,#datepicker2').datepicker({
                    dateFormat: 'dd/mm/yy',
                    dayNames: ['Domingo', 'Segunda', 'Terça', 'Quarta', 'Quinta', 'Sexta', 'Sábado'],
                    dayNamesMin: ['D', 'S', 'T', 'Q', 'Q', 'S', 'S', 'D'],
                    dayNamesShort: ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'],
                    monthNames: ['Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho', 'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'],
                    monthNamesShort: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'],
                    nextText: 'Próximo',
                    prevText: 'Anterior',
                    changeMonth: true,
                    changeYear: true,
                    minDate: start,
                    maxDate: end,
                    yearRange: -100 + ':' + end.getFullYear(),
                });
            });

        </script>

    </head>
    <body>
        <!--Inclui cabeçalho-->
        <jsp:include page="navGerente.jsp"/>

        <div class="container">
            <div class="row">
                <div class="col-md-3">
                    <p class="lead">Magazine Store</p>
                    <div class="list-group">
                        <a href="buscarCliente.jsp" class="list-group-item">Buscar Cliente</a>
                        <a href="../administrador/cadastrarProduto.jsp" class="list-group-item">Cadastrar Produto</a>
                        <a href="../administrador/cadastrarCategoria.jsp" class="list-group-item">Cadastrar Categoria</a>
                        <a href="../administrador/cadastrarEditora.jsp" class="list-group-item">Cadastrar Editora</a>
                    </div>
                </div>
                <div class="col-md-9 ">   
                    <h1>Funcionários</h1>
                <form action="./Gerentes?action=buscarf" method="post" class="form-horizontal">
                        <div class="form-group">
                        <div class="row">
                            <label class="col-md-2 control-label pull-left clearfix" for="">Buscar por:</label>
                        </div>
                           <div class="col-md-2">
                            <select name="escolha" class="form-control">
                                <option value="nome" ${escolha == 'nome' ? 'selected' : ''}>Nome</option>
                                <option value="cpf" ${escolha == 'cpf' ? 'selected' : ''}>CPF</option>
                                <option value="email" ${escolha == 'email' ? 'selected' : ''}>Email</option>
                            </select>
                        </div>
                            <div class="col-md-7">
                                <input type="text" name="str" id="" class="form-control" placeholder="1234" value="${str}">
                            </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-success  btn-block ">Buscar</button>
                        </div>
                    </div>
                </form>
                    <table class="table table-striped table-bordered">
                        <tr>
                            <th>Nome</th>
                            <th>CPF</th>
                            <th>Perfil</th>
                            <th>Ação</th>
                        </tr>
                        <c:forEach var="usuario" items="${listaClientes}">
                            <tr>
                                <td>${usuario.nome}</td>
                                <td>${usuario.cpf}</td>
                            <c:if test="${usuario.perfil == 2}">
                                <td>Administrador</td>
                            </c:if>
                            <c:if test="${usuario.perfil == 3}">
                                <td>Gerente</td>
                            </c:if>
                            <td>
                                <div class="text-center">
                                    <form action="./Gerentes?action=visualizarf&id=${usuario.idCliente}" method="post" style="display: inline">
                                        <a href="#" onclick="this.parentNode.submit();">
                                            <span class="glyphicon glyphicon-eye-open" style="font-size: 20px"></span>
                                            <input type="hidden" value="${escolha}" name="escolha"/>
                                            <input type="hidden" value="${str}" name="str"/>
                                        </a>
                                    </form>
                                    <form action="./Gerentes?action=valterarf&id=${usuario.idCliente}" method="post" style="display: inline">
                                        <a href="#" onclick="this.parentNode.submit();">
                                            <span class="glyphicon glyphicon-pencil" style="font-size: 20px"></span>
                                            <input type="hidden" value="${escolha}" name="escolha"/>
                                            <input type="hidden" value="${str}" name="str"/>
                                        </a>
                                    </form>
                                    <form action="./Gerentes?action=excluirf&id=${usuario.idCliente}" method="post" style="display: inline">
                                        <a href="#" onclick="this.parentNode.submit();">
                                            <span class="glyphicon glyphicon-trash" style="font-size: 20px"></span>
                                            <input type="hidden" value="${escolha}" name="escolha"/>
                                            <input type="hidden" value="${usuario.perfil}" name="perfil"/>
                                            <input type="hidden" value="${str}" name="str"/>
                                        </a>
                                    </form>
                                </div>
                            </td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>
        </div>
        <!--Inclui Rodapé-->
        <jsp:include page="../comum/rodape.jsp"/>

        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>