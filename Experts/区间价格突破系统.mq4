//+------------------------------------------------------------------+
//|                                                     区间价格突破系统.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <zym.mqh>
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

extern int Period = 8;
extern int Stopless = 500;
extern int Profit = 2000;
extern double Volumn = 0.1;

bool CLOSE_flag = 0;
void start(){
   double order_volumn = Volumn;
   double highest = iHigh(Symbol(),0,iHighest(Symbol(),0,MODE_HIGH,Period,1));
   double lowest = iLow(Symbol(),0,iLowest(Symbol(),0,MODE_LOW,Period ,1));
   double atr = iATR(NULL,0,20,0);
   Print("当前开盘价："+Open[0]+"，过去最高价："+highest+"，最低价；"+lowest);
   if(Ask>highest){
      ClosePosition(OP_SELL);
      if(OrdersTotal()==0){
         int order = OrderSend(NULL,OP_BUY,order_volumn,Ask,50,Bid-Point*Stopless,Bid+Point*Profit);
         printError("买入"+Symbol(),order);
      }
   }
   if(Bid<lowest){
      ClosePosition(OP_BUY);
      if(OrdersTotal()==0){
         int order = OrderSend(NULL,OP_SELL,order_volumn,Bid,50,Ask+Point*Stopless,Ask-Point*Profit);
         printError("卖出"+Symbol(),order);
      }
   }
}