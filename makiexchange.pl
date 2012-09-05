#!/usr/bin/perl -w

###############################################################################################
#  
#  MakiExchange v0.1
#   
#  Copyright (c) 2011-2012 Cesar Gutierrez Tineo
#  Released under the MIT license
#
#  Se autoriza por la presente, de forma gratuita, a cualquier
#  persona que haya obtenido una copia de este software y 
#  archivos asociados de documentación (el "Software"), para tratar en el
#  Software sin restricción, incluyendo sin ninguna limitación en lo que concierne
#  los derechos para usar, copiar, modificar, fusionar, publicar,
#  distribuir, sublicenciar, y / o vender copias de este
#  Software, y para permitir a las personas a las que se les proporcione el Software para 
#  hacer lo mismo, sujeto a las siguientes condiciones:
#  
#  El aviso de copyright anterior y este aviso de permiso
#  tendrá que ser incluido en todas las copias o partes sustanciales de
#  este Software.
#  
#  EL SOFTWARE SE ENTREGA "TAL CUAL", SIN GARANTÍA DE NINGÚN
#  TIPO, EXPRESA O IMPLÍCITA, INCLUYENDO PERO SIN LIMITARSE A GARANTÍAS DE
#  MERCANTIBILIDAD, CAPACIDAD DE HACER Y DE NO INFRACCIÓN DE COPYRIGHT. EN NINGÚN 
#  CASO LOS AUTORES O TITULARES DEL COPYRIGHT SERÁN RESPONSABLES DE 
#  NINGUNA RECLAMACIÓN, DAÑOS U OTRAS RESPONSABILIDADES, 
#  YA SEA EN UN LITIGIO, AGRAVIO O DE OTRO MODO, 
#  DERIVADAS DE, OCASIONADAS POR CULPA DE O EN CONEXION CON EL
#  SOFTWARE O SU USO U OTRO TIPO DE ACCIONES EN EL SOFTWARE.
#
###############################################################################################
use strict;
use CGI::Carp qw(fatalsToBrowser);

use LWP::UserAgent;
use LWP::Simple;

use HTTP::Request;

use HTML::TreeBuilder;
use HTML::Element;
use HTML::Parser;

#pagina de la sunat
my $url = "http://www.sunat.gob.pe/cl-at-ittipcam/tcS01Alias";
print $url."\n";


#Obteber la fecha de servidor
my @timeData = localtime(time);
my $dia =  $timeData[3];
my $mes =  $timeData[4] +1;

my $ano =  1900 + $timeData[5];
if($mes<10){$mes= "0".$mes;}
if($dia<10){$dia= "0".$dia;}
my $fecha = $ano."-".$mes."-".$dia;
print "Fecha de hoy : $fecha\n";

my $dbh ;
my $dbh1 ;
#obtener la pagina de la sunat
my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/4.0 (compatible; MSIE 5.0; Windows 98; DigExt)");
my $req = HTTP::Request->new(GET => $url);
my $response = $ua->request($req);

#verificamos la conexion
if ($response->is_success) {
        print "conectado correctamente a SUNAT.\n";

        my $content = $response->content();

        my $tree =  HTML::TreeBuilder->new_from_content($content);
        my @anchors = $tree->look_down("class","tne10");

        my $tam = scalar @anchors;
        my $index = $tam-1;

	#verificamos tipo de cambio disponible
	if($tam>0){
        	print "Nuevos tipos de cambio : ".$anchors[$index-1]->as_text().",".$anchors[$index]->as_text()."\n";
	}else{
	  	print "Este mes no tiene aun tipo de cambio :(\n";	
	}

}else{
	#no hay conexion a SUNAT ._.?
	print "no se puedo conectar a SUNAT\n";
}

