<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!-- Navigation -->
<nav class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container">
        <!-- Brand and toggle get grouped for better mobile display -->
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="index.jsp"><img style="width: 260px" src="../images/logo.png"/></a>
        </div>
        <!-- Collect the nav links, forms, and other content for toggling -->
        <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
            <!--<ul class="nav navbar-nav">
                <li>
                    <a href="#">Produtos</a>
                </li>
            </ul>-->

            <ul class="nav pull-right navbar-nav">
                <li class="dropdown" id="menuLogin">
                    <a class="dropdown-toggle" href="#" data-toggle="dropdown" id="navLogin">Login<strong class="caret"></strong></a>

                    <div class="dropdown-menu pull-left" style="padding:17px; min-width: 0px;">
                        <form class="form" id="formLogin" action="../cliente/index.jsp">
                            <div style="padding: 5px">
                                <input name="email" id="username" type="text" placeholder="Username">
                            </div>
                            <div style="padding: 5px">
                                <input name="password" id="password" type="password" placeholder="Password"><br>
                            </div>
                            <div style="padding: 5px">
                                <button type="submit" id="btnLogin" class="btn" >Login</button>
                            </div>
                        </form>
                    </div>
                </li>
                <li>
                    <a href="cadastrarCliente.jsp"> Cadastrar </a>
                </li>
                <li class="dropdown" id="menuLogin">
                    <a class="dropdown-toggle" href="#" data-toggle="dropdown" id="navLogin">
                        <span class="glyphicon glyphicon-shopping-cart"></span>
                        Carrinho [3 Itens]<strong class="caret"></strong>

                    </a>

                    <div class="dropdown-menu pull-right" style="padding:5px;">
                        <table class="table table-striped">
                            <tr>
                                <th>Item</th>
                                <th>Quantidade</th>
                                <th>Total</th>
                            </tr>
                            <tr>
                                <td><span class="glyphicon glyphicon-picture"></span> Turma da Monica Ed.50</td>
                                <td>50</td>
                                <td>R$ 109,90</td>
                            </tr>
                            <tr>
                                <td><span class="glyphicon glyphicon-picture"></span> Wolverine Aniversário</td>
                                <td>1</td>
                                <td>R$ 85,60</td>
                            </tr>
                            <tr>
                                <td><span class="glyphicon glyphicon-picture"></span> Casa e Construção maio/2015</td>
                                <td>2</td>
                                <td>R$ 10,99</td>
                            </tr>
                        </table>
                        <a href="login.jsp"><button class="btn btn-default">Ver Carrinho</button></a>
                        <h4 class="pull-right">Total R$340,00</h4>
                    </div>
                </li>
            </ul>

        </div>
        <!-- /.navbar-collapse -->
    </div>
    <!-- /.container -->
</nav>