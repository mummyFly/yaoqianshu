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
   double kdj1 = iCustom(NULL,PERIOD_M5,"KDJ",0,1);
   double kdj2 = iCustom(NULL,PERIOD_M5,"KDJ",0,2);
  
   Print("kdj1:"+kdj1+",kdj2:"+kdj2);
   if(kdj1>80&&kdj2<80){
      if(OrdersTotal()==0){
         int order = OrderSend(NULL,OP_BUY,order_volumn,Ask,50,Bid-Point*Stopless,Bid+Point*Profit);
         printError("买入"+Symbol(),order);
      }
   }
   if(kdj1<30&&kdj2>30){
      if(OrdersTotal()==0){
         int order = OrderSend(NULL,OP_SELL,order_volumn,Bid,50,Ask+Point*Stopless,Ask-Point*Profit);
         printError("卖出"+Symbol(),order);
      }
   }
}