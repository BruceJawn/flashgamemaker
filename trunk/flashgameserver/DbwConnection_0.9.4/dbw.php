<?php

//;;;;;;;;;;;;;;;;;;;;;;;;
//; Code (don't modify ) ;
//;;;;;;;;;;;;;;;;;;;;;;;;


// if it's a submit :
if(isset($_POST['username']) && isset($_POST['psw'])){
	
	mysql_connect($_POST['host'],$_POST['username'],$_POST['psw']) or die ("<dwbError type=\"parameters mysql\">");
	
	mysql_select_db($_POST['db']) or die("<dwbError type=\"parameters mysql\">");
	
	$_POST['request'] = stripslashes($_POST['request']);
	
	//execute update
	if($_GET['type'] == "update"){
	
		//mysql_query($_POST['request']);
		echo(mysql_query($_POST['request']));
        
		die();
		
	}
	
	// execute Query and display result
	if($_GET['type'] == "query"){
		
		
		
		$res = mysql_query($_POST['request']);
		
		
		if ($res > 0 || $res == ""){
			
			if($res == ""){
				echo "<dwbError type=\"query invalid\">";
				die();
			}
			
			
			// display column name :
			if(mysql_num_rows($res) !== 0)	{
				
				echo "<dbwNameOfColumn>";
				
				$row = mysql_fetch_row($res);
	
				for($j = 0, $c = count($row); $j < $c; $j++)	{
					
					echo "<dbwColumnName".$j.">".mysql_field_name($res, $j)."</dbwColumnName".$j.">";
					
				}
				
				echo "</dbwNameOfColumn><br>\n";
				
			
				// diplay all data :
			
				mysql_data_seek($res, 0);

			
				while ($line = mysql_fetch_row($res)){
		      		
		      		echo "<dbwline>";
		      		
		      		for($j = 0, $c = count($row); $j < $c; $j++)	{
						
						echo "<dbwColumn".$j.">".$line[$j]."</dbwColumn".$j.">";
						
					}
					
					echo "</dbwline><br>\n";
		
		   		}
	   		
			}
   		
		}else{
			
			echo "<dwbError type=\"query invalid\">";	
		}

	}

// if it's not a submit :

}else{
	
	
	// check indetification
	if(isset($_GET['username']) && isset($_GET['psw']) && @$_GET['type'] =="query" || @$_GET['type'] == "update"){
		
		echo "<version>0.9.4</version>";
		
		$link = mysql_connect($_GET['host'],$_GET['username'],$_GET['psw']) or die ("<dwbError type=\"parameters mysql\">");
		
		mysql_select_db($_GET['db'], $link) or die("<dbwError type=\"name_dataBase\">");
	
		echo "<encoding>".mysql_client_encoding($link)."</encoding>";
		
		//diplay the page for query or update
		
		echo "<html>\n";
		
		echo "<form METHOD=\"POST\">\n";
		
		echo "<input type=\"text\" name=\"request\">\n";
		
		echo "<INPUT type=\"hidden\" name=\"username\" value=\"".$_GET['username']."\">\n";
		
		echo "<INPUT type=\"hidden\" name=\"psw\" value=\"".$_GET['psw']."\">\n";
		
		echo "<INPUT type=\"hidden\" name=\"db\" value=\"".$_GET['db']."\">\n";
		
		echo "<INPUT type=\"hidden\" name=\"host\" value=\"".$_GET['host']."\">\n";
		
		echo "</form>\n";
				
	}
	
}

?>