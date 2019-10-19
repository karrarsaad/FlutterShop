import 'package:flutter/material.dart';
import 'package:generalshop/api/authentication.dart';
import 'package:generalshop/api/products_api.dart';
import 'package:generalshop/product/product.dart';

void main (){
  runApp(GeneralShop());
}
class GeneralShop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'General Shop',
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsApi productsApi=ProductsApi();
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text('General Shop'),),
      body:FutureBuilder(
            future:productsApi.fetchproduct(4),
            builder: (BuildContext context,AsyncSnapshot<Product> snapShot){
              switch(snapShot.connectionState){

                case ConnectionState.none:
                  return   _error('nothing');
                  break;
                case ConnectionState.waiting:
                  return  _loading();
                  break;
                case ConnectionState.active:
                  return _loading();
                  break;
                case ConnectionState.done:
                  if(snapShot.hasError){
                    return _error(snapShot.error);
                  }else{
                    if(!snapShot.hasData){
                      return _error('no data');
                    }else{
                      return _drawProduct(snapShot.data);

                    }
                  }


                  break;
              }
              return Container();
            },
          ),

    );
  }

  _drawProduct(Product product){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(product.product_title),
            (product.images.length>0 )?
            Image(image: NetworkImage(product.images[1]),):Container(),
          ],
        ),
      ),
    );
  }


  _error(var error){
    return Container(
      child: Center(
        child: Text(error.toString()),
      ),
    );
  }
  _loading(){
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

