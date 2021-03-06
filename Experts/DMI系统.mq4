//+------------------------------------------------------------------+
//|                                                         白线战法.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <zym.mqh>
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int MA_period = 5;
extern int MA_period2 = 20;
extern int CCI_period = 100;
extern int volumn = 1;
extern double MAX_stopless = 500;
extern int ORDER_stopless = 500;
extern int ADD_profit = 200;
extern int Trailing_start = 200;
extern int MAX_lose = 7000;
extern int MAX_profit = 2000;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double accountProfit = Trailing_start;
extern double percent = 0.1;
int flag = 1;
int CLOSE_flag = 0;
int day_flag = 30;
int order_volumn = (AccountBalance()*percent/MAX_lose)*volumn;
//int order_volumn = volumn;

void start(){
   
   double ma = iMA(NULL,0,MA_period,0,MODE_SMA,PRICE_CLOSE,0);
   double ma2 = iMA(NULL,0,MA_period2,0,MODE_SMA,PRICE_CLOSE,0);
   //double bbi = iCustom(NULL,0,"BBI",0,0);
   double cci = iCCI(NULL,0,CCI_period,PRICE_CLOSE,0);
   double cci1 = iCCI(NULL,0,CCI_period,PRICE_CLOSE,1);
   
   if(cci>0&&cci1>0){
      //if(cci<100){
         //Print("cci过低");
         //ClosePosition(OP_BUY);
      //}
      ClosePosition(OP_SELL);
      if(OrdersTotal()==0){
         flag=1;
         accountProfit = Trailing_start;
      }
      if(OrdersTotal()==0 
      //&& CLOSE_flag == OP_SELL
      ){
         //Print("当前ma："+ma+"，当前bbi："+bbi);
         Print("开始买入");
         int order = OrderSend(NULL,OP_BUY,order_volumn,Ask,0,0,0);
         printError("买入"+Symbol(),order);
      }
   }else if(cci<0&&cci1<0){ 
      //if(cci>-100){
         //Print("cci过高");
         //ClosePosition(OP_SELL);
      //}
      ClosePosition(OP_BUY);   
      if(OrdersTotal()==0){
         flag=1;
         accountProfit = Trailing_start;
      }
      if(OrdersTotal()==0 
      //&& CLOSE_flag == OP_BUY
      ){
         //Print("当前ma："+ma+"，当前bbi："+bbi);
         Print("开始卖出");
         int order = OrderSend(NULL,OP_SELL,order_volumn,Bid,0,0,0);
         printError("卖出"+Symbol(),order);
      }
   }
   if(AccountProfit()<(0-MAX_stopless)||AccountProfit()>MAX_profit){
      ClosePosition(OP_BUY);
      ClosePosition(OP_SELL);
      flag=1;
      accountProfit = Trailing_start;
   }
   Comment("当前账户盈利："+AccountProfit()+"flag："+flag);
   if(AccountProfit()>(((flag*flag-flag+2)/2)*ADD_profit)&&AccountBalance()>2000){
      flag++;
      OrderSelect(0, SELECT_BY_POS, MODE_TRADES);
      if(OrderType()==OP_BUY){
         Print("当前盈利"+AccountProfit()+"，加仓多单");
         int order = OrderSend(NULL,OP_BUY,order_volumn,Ask,0,0,0);
         printError("买入"+Symbol(),order);
      }else if(OrderType()==OP_SELL){
         Print("当前盈利："+AccountProfit()+"，加仓空单");
         int order = OrderSend(NULL,OP_SELL,order_volumn,Bid,0,0,0);
         printError("卖出"+Symbol(),order);
      }
   }
   if(OrdersTotal()>0){
      TrailingProfit();
   }
   
}


void TrailingProfit(){
   if(accountProfit>=AccountProfit()&&AccountProfit()>Trailing_start){
      Print("当前盈利："+AccountProfit()+"，开始平仓");
      ClosePosition(OP_BUY);
      ClosePosition(OP_SELL);
   }
   if(accountProfit<=AccountProfit()*(1-percent)){
      accountProfit = AccountProfit()*(1-percent);
      Print("追踪止盈上调至:"+accountProfit);
   }
   
}


