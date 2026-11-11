<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->

        <title>Cadastro de Cliente</title>
            
        <!--JQuery CSS-->
        <link rel="stylesheet" href="../js/jquery-ui.css">
        
        <!-- Bootstrap -->
        <link href="../css/bootstrap.min.css" rel="stylesheet" />

        <!-- Custom CSS -->
        <link href="../css/shop-homepage.css" rel="stylesheet" />
        
        <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
        <script src="../js/jquery.min.js"></script>
        <script src="../js/jquery-ui.js"></script>

        
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
            <div class=" col-sm-offset-3 col-sm-6">
        <h1>Dados Cadastrais</h1>
        <form class="form-horizontal" id="form" onsubmit="return valida(this);">
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Nome Completo</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" id="" placeholder="" value="José da Silva Sauro" disabled="disabled">
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Sexo</label>
                <div class="col-sm-8">
                    <select name="sexo" id="sexo" class="form-control" disabled="disabled">
                        <option >Selecione</option>
                        <option value="m" selected="selected" required>Masculino</option>
                        <option value="f" required>Feminino</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">CPF</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" maxlength="14" id="cpf" value="123.432.324-66" placeholder="000.000.000-00"  disabled="disabled"/>
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Data de Nascimento</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" maxlength="10" value="31/12/2004" id="datepicker" placeholder="dd/mm/aaaa" disabled="disabled"/>
                </div>
            </div>      
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Telefone</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" maxlength="14" id="" value="041-3456-3423" placeholder="DDD-0000-00000"  disabled="disabled"/>
                </div>
            </div>  
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Email</label>
                <div class="col-sm-8">
                    <input type="email" class="form-control"  id="" placeholder="seuemail@dominio.com" value="silva@sauro.cao" disabled="disabled"/>
                </div>
            </div>             
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Senha</label>
                <div class="col-sm-8">
                    <input type="password" class="form-control" value="123456" id="" placeholder="" disabled="disabled"/>
                </div>
            </div> 
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Confirme sua Senha</label>
                <div class="col-sm-8">
                    <input type="password" class="form-control" id="" value="123456" placeholder="" disabled="disabled"/>
                </div>
            </div>       
            
            <h2>Endereço de Entrega</h2>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">CEP</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="87654-987" maxlength="9" id="" placeholder="00000-000" OnKeyPress="formatar(this,'#####-###')" disabled="disabled" />
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Endereço</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="Rua dos Alfeneiros" id="" placeholder="" disabled="disabled" />
                </div>
            </div>            
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Número</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="12345" id="" placeholder="" disabled="disabled" />
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Complemento</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="Casa" id="" placeholder="" disabled="disabled" />
                </div>
            </div>            
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Bairro</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="Boas Novas" id="" placeholder="" disabled="disabled" />
                </div>
            </div>  
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Cidade</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="Seattle" id="" placeholder="" disabled="disabled" />
                </div>
            </div>
            <div class="form-group">
                <label for="" class="col-sm-4 control-label">Estado</label>
                <div class="col-sm-8">
                    <input type="text" class="form-control" value="PA" id="" placeholder="" disabled="disabled" />
                </div>
            </div> 
            <div class="form-group">
                <div class="col-sm-offset-4 col-sm-8">
                    <button type="submit" class="btn btn-success btn-lg btn-block ">Voltar</button>
                </div>
            </div>
        </form>
        </div>
</div>
        
        <!--Inclui Rodapé-->
        <jsp:include page="../comum/rodape.jsp"/>    


        <!-- Include all compiled plugins (below), or include individual files as needed -->
        <script src="../js/bootstrap.min.js"></script>
    </body>
</html>