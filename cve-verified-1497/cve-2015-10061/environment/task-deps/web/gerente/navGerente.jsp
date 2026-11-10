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
                <ul class="nav navbar-nav">
                    <li>
                        <a href="#">Home</a>
                    </li>
                    <li>
                        <a href="#">Serviços</a>
                    </li>
                    <li>
                        <a href="#">Contato</a>
                    </li>
                </ul>
                <ul class="nav pull-right navbar-nav">
                    <li class="dropdown" id="menuCliente">
                      <a class="dropdown-toggle" href="#" data-toggle="dropdown" id="navCliente">
                          <span class="glyphicon glyphicon-picture"></span> Razer Gerente<strong class="caret"></strong>
                      
                      </a>
                      
                      <div class="dropdown-menu pull-right" style="padding:5px;  min-width: 200px;">
                          <ul>
                              <a href="#">
                              <li>Alterar Perfil</li>
                              </a>
                              <a href="#">
                              <li>Logout</li>
                              </a>
                          </ul>
                      </div>
                    </li>
                    <li class="dropdown" id="menuLogin">
                      <a class="dropdown-toggle" href="#" data-toggle="dropdown" id="navLogin">
                          <span class="glyphicon glyphicon-shopping-cart"></span>
                          Carrinho [0 Itens]<strong class="caret"></strong>
                      
                      </a>
                      
                      <div class="dropdown-menu pull-right" style="padding:5px;">
                          <table class="table table-striped">
                              <tr>
                                <th>Item</th>
                                <th>Quantidade</th>
                                <th>Total</th>
                              </tr>
                              <tr>
                                  <td><span class="glyphicon glyphicon-picture"> Turma da Monica Ed.50</span></td>
                                  <td>50</td>
                                  <td>R$ 109,90</td>
                              </tr>
                              <tr>
                                <td><span class="glyphicon glyphicon-picture"> Wolverine Aniversário</span></td>
                                  <td>1</td>
                                  <td>R$ 85,60</td>
                              </tr>
                              <tr>
                                  <td><span class="glyphicon glyphicon-picture"> Casa e Construção maio/2015</span></td>
                                  <td>2</td>
                                  <td>R$ 10,99</td>
                              </tr>
                          </table>
                          <button class="btn btn-default">Ver Carrinho</button>
                          <h4 class="pull-right">Total R$340,00</h4>
                      </div>
                    </li>

              </ul>
            </div>
            <!-- /.navbar-collapse -->
        </div>
        <!-- /.container -->
    </nav>

