#!/usr/bin/perl -w

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

