//+------------------------------------------------------------------+
//|                                                         三角套利.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
extern string symbol1 = "GBPUSD";
extern string symbol2 = "USDJPY";
extern string symbol = "GBPJPY";
extern double lots = 0.01;
extern double slip = 0.04;

void start(){
   double symbol1_bid = MarketInfo(symbol1,MODE_BID);
   double symbol1_ask = MarketInfo(symbol1,MODE_ASK);
   double symbol2_bid = MarketInfo(symbol2,MODE_BID);
   double symbol2_ask = MarketInfo(symbol2,MODE_ASK);
   
   double symbol_bid = MarketInfo(symbol,MODE_BID);
   double symbol_ask = MarketInfo(symbol,MODE_ASK);
   double symbol_BID = symbol1_bid*symbol2_bid;
   double symbol_ASK = symbol1_ask*symbol2_ask;
   Comment(symbol1+"的市场买入价："+symbol1_ask+"，"+symbol1+"的市场卖出价："+symbol1_bid
         +"\n\n"+symbol2+"的市场买入价："+symbol2_ask+"，"+symbol2+"的市场卖出价："+symbol2_bid
         +"\n\n"+symbol+"的合成买入价："+symbol_ASK+"，"+symbol+"的合成卖出价："+symbol_BID
         +"\n\n"+symbol+"的市场卖出价："+symbol_bid+"，"+symbol+"的市场买入价："+symbol_ask);
   if(symbol_bid-symbol_ASK>slip){
      Print("开始买入"+symbol);
      int id = OrderSend(symbol,OP_BUY,lots,Ask,0,0,symbol_bid);
      printError("买入"+symbol+"出错",id);
   }else if(symbol_BID-symbol_ask>slip){
      Print("开始卖出"+symbol);
      int id = OrderSend(symbol,OP_SELL,lots,Bid,0,0,symbol_ask);
      printError("卖出"+symbol+"出错",id);
   }
      
}
void printError(string msg,int id){
   if(id<0){
      Print(msg+"OrderSend 失败错误 #",GetLastError());
   }
}
