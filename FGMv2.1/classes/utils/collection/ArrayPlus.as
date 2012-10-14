/**
 * ARRAYPLUS || Neamar
 * La classe ArrayPlus tente de pallier aux déficits de la classe Array interne à ActionScript.
 * Elle apporte plusieurs méthodes utiles, parmi lesquelles :
 * - uniquePush qui insère l'élément s'il n'est pas encore dans le tableau.
 * - clone qui renvoie un clone de l'objet ;
 * - contains qui vaut true si l'item spécifié en paramètre est présent dans le tableau
 * - remove supprimer l'élement
 * - swap échange l'ordre de deux élements
 * 
 * Cette classe présente l'avantage d'être assez similaire à DictionaryPlus, permettant d'échanger de façon transparente les deux types de données selon les besoins.
 * 
 * MÉTHODES STATIQUE :
 * - concat : renvoie la concaténation des deux tableaux passés en paramètres.
 * - Dictionary2Array : transforme un DictionaryPlus en ArrayPlus. Attention, il y a perte d'informations !
 * http://blog.neamar.fr/accueil/15-as3/45-array-remove-action-script-3
 */

package utils.collection{
	public dynamic class ArrayPlus extends Array{
	/**
	 * Crée un nouveau ArrayPlus à partir des paramètres.
	 * @param ... Liste d'items à enregistrer
	 */
		public function ArrayPlus(...Items){
			for each(var Item:* in Items)
				this.push(Item);
		}
		
		/**
		 * Ajoute un élément de façon unique dans le tableau.
		 * @param item L'élément à ajouter s'il n'es tpas déjà présent
		 */
		public function uniquePush(item:*):void{
			if(!this.contains(item))
				this.push(item);
		}
		
		/**
		 * Clone l'objet et renvoie une nouvelle occurrence d'ArrayPlus avec un contenu identique.
		 * @return Le clone de l'objet
		 */
		public function clone():ArrayPlus{
			var Bis:ArrayPlus=new ArrayPlus();
			for each(var i:* in this)
				Bis.push(i);
				return Bis;
		}
		
		/**
		 * Filtrer une partie des éléments du tableau selon une fonction de Callback.
		 * @param Callback Une fonction qui renvoie true si l'élément doit figurer dans le nouveau tableau, false sinon.
		 * @return Le tableau avec tous les éléments pour lesquels Callback vaut true.
		 */
		public function filtrer(Callback:Function):ArrayPlus{
			var Retour:ArrayPlus=new ArrayPlus();
			for each(var item:* in this){
				if(Callback.call(this,item))
					Retour.push(item);
			}
			return Retour;
		}
		
		/**
		 * Déterminer si un élément appartient au tableau.
		 * @param item L'élement à tester
		 * @return true si présent, false sinon
		 */
		public function contains(item:*):Boolean{
			return (this.indexOf(item)!=-1)
		}
		
		/**
		 * Supprime un élément du tableau. Attention, ne le supprime qu'une fois s'il est présent en doublons ! Si l'élément n'est pas présent, une erreur est lancée.
		 * @param item L'élément à supprimer.
		 */
		public function remove(item:*,error:Boolean = true):void{
			var id:int=this.indexOf(item);
			if(id!=-1)
				this.splice(id,1);
			else if(error)
				throw new Error("Suppression d'un item inexistant");
			else
				trace("[WARNING] Suppression d'un item inexistant");
		}
		
		/**
		 * Remplace une occurrence d'un élément par un autre élément.
		 * @param search Élément à chercher
		 * @param replace Élément de remplacement
		 */
		public function replace(search:*,replace:*):void{
			var id:int=this.indexOf(search);
			if(id!=-1)
				this.splice(id,1,replace);
			else
				throw new Error("Remplacement d'un item inexistant");
		}
		
		/**
		 * Inverse la position de item avec la position de item2
		 * @param item Premier élément
		 * @param item2 Second élément
		 */
		public function swap(item:*,item2:*):void{
			var switcher:Object=new Object();
			replace(item,switcher);
			replace(item2,item);
			replace(switcher,item);
		}
		
		/**
		 * Renvoie tous les éléments contenus dans le tableau sous forme de String
		 * @return Liste concaténée par des sauts de ligne des éléments du tableau
		 */
		public function toString():String{
			  var S:String="";
			  for each(var item:* in this)
			  S += item.toString() + "\n";
			  return S;
		  }
		  
		  
		  //STATIQUE
		  
		  /**
		   * Concatène les deux tableaux passés en paramètre et renvoie le résultat.
		   * @param a Le premier ArrayPlus
		   * @param b Le second ArrayPlus
		   * @return L'ArrayPlus contenant tous les éléments de a et de b.
		   */
		  public static function concat(a:ArrayPlus,b:ArrayPlus):ArrayPlus{
			  var retour:ArrayPlus=a.clone();
			  for each(var items:* in b)
			  retour.push(items);
			  return retour;
		  }
	  }
  }