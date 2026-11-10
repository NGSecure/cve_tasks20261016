<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
		dayNames: ['Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado'],
		dayNamesMin: ['D','S','T','Q','Q','S','S','D'],
		dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'],
		monthNames: ['Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
		monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'],
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
            <h1>Relatório de Compras de Clientes</h1>
            <table class="table table-striped table-bordered">
                <tr>
                    <th colspan="3" style="font-size: 25px">Bruno Sella</th>
                </tr>
                <tr>
                    <th>Número da Compra #</th>
                    <th>Data</th>
                    <th>Valor Total</th>
                </tr>
                <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                 <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                </tr>
                 <tr>
                     <td colspan="2" style="text-align: right"><strong>Total</strong></td>
                    <td >R$ 204,40</td>
                </tr>
                <tr>
                    <th colspan="3" style="font-size: 25px">Evandro Luís</th>
                </tr>
                <tr>
                    <th>Número da Compra #</th>
                    <th>Data</th>
                    <th>Valor Total</th>
                </tr>
                <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                 <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                </tr>
                 <tr>
                     <td colspan="2" style="text-align: right"><strong>Total</strong></td>
                    <td >R$ 204,40</td>
                </tr>
                <tr>
                    <th colspan="3" style="font-size: 25px">Yuri Jungles</th>
                </tr>
                <tr>
                    <th>Número da Compra #</th>
                    <th>Data</th>
                    <th>Valor Total</th>
                </tr>
                <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                 <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                </tr>
                 <tr>
                     <td colspan="2" style="text-align: right"><strong>Total</strong></td>
                    <td >R$ 204,40</td>
                </tr>
                <tr>
                    <th colspan="3" style="font-size: 25px">Razer Anthom</th>
                </tr>
                <tr>
                    <th>Número da Compra #</th>
                    <th>Data</th>
                    <th>Valor Total</th>
                </tr>
                <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                                               <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                 </tr>
                 <tr>
                    <td>183</td>
                    <td>12/11/2015</td>
                    <td>R$ 204,40</td>
                </tr>
                 <tr>
                     <td colspan="2" style="text-align: right"><strong>Total</strong></td>
                    <td >R$ 204,40</td>
                </tr>

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