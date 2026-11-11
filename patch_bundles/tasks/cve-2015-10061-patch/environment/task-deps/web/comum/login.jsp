<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="pt-br">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>HQ Shop</title>

    <!-- Bootstrap Core CSS -->
    <link href="../css/bootstrap.css" rel="stylesheet">

    <!-- Custom CSS -->
    <link href="../css/shop-homepage.css" rel="stylesheet">

    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->

</head>

<body>

   <!--Inclui cabeçalho-->
   <jsp:include page="navAnonimo.jsp"/>

    <!-- Page Content -->
    <div class="container">

        <div class="row">
            <h1>Login</h1>
            <p>${mensagem}</p>
            <form id="signupform" action="" method="POST" role="form">
                <div class="row">
                <div class="form-group col-lg-4"> 
                    <label for="email">Email: </label>
                    <input type="email" class="form-control " id="email" name="email" placeholder="Insira seu email" required/>
                </div>
                </div>
                <div class="row">
                <div class="form-group col-lg-2">
                    <label for="senha">Senha: </label>
                    <input type="password" class="form-control" id="senha" name="senha" placeholder="Insira sua senha" required/>
                </div>
                </div>
                <button type="submit" class="btn btn-default">Enviar</button>
            
            
            </form>
        </div>
        <!--/.row-->
        
  
    <!--Inclui Rodapé-->
    <jsp:include page="rodape.jsp"/>
    
    <!-- jQuery -->
    <script src="../js/jquery.min.js"></script>

    <!-- Bootstrap Core JavaScript -->
    <script src="../js/bootstrap.min.js"></script>

</body>

</html>
