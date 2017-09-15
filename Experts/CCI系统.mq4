//+------------------------------------------------------------------+
//|                                                         白线战法.mq4 |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include <zym.mqh>
#property copyright "Copyright 2017, mummyFly."
#property link      "https://github.com/mummyFly/yaoqianshu.git"
#property version   "1.00"
#property description   "摇钱树系统只限于个人交流学习之用，严禁转载或商用。\n对未经允许私自转载并利用本系统获利的行为，本人依法保留一切追究诉讼权利。\n转载或商务合作请联系QQ:935701575，备注摇钱树合作。"
#property strict

extern int CCI_period = 14;
extern double volumn = 1;
extern double MAX_stopless = 50;
extern double ADD_profit = 20;
extern double Trailing_start = 20;
extern double MAX_profit = 200;
extern double Start_account = 10000;
extern bool IS_add_order = true;
extern double Percent = 0.6;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
double accountProfit = Trailing_start;

int flag = 1;
int CLOSE_flag = 0;
int day_flag = 30;


double max_profit = MAX_profit*volumn;
double max_stopless = MAX_stopless*volumn;
double trailing_start = Trailing_start*volumn;
double add_profit = ADD_profit*volumn;

void start(){
   //double order_volumn = (AccountBalance()*percent/MAX_lose)*volumn;
   double order_volumn = volumn;
   if(IS_add_order){
      order_volumn = (AccountBalance()/Start_account)*volumn;
   }
   
   max_profit = MAX_profit*order_volumn;
   max_stopless = MAX_stopless*order_volumn;
   trailing_start = Trailing_start*order_volumn;
   add_profit = ADD_profit*order_volumn;
   
   double cci = iCCI(NULL,0,CCI_period,PRICE_CLOSE,1);
   double cci1 = iCCI(NULL,0,CCI_period,PRICE_CLOSE,2);
      
   if(cci>0&&cci1<0){
      ClosePosition(OP_SELL);
      if(OrdersTotal()==0){
         flag=1;
         accountProfit = trailing_start;
      }
      if(OrdersTotal()==0){
         Print("开始买入");
         int order = OrderSend(NULL,OP_BUY,order_volumn,Ask,0,0,0);
         printError("买入"+Symbol(),order);
      }
   }else if(cci<0&&cci1>0){ 
      ClosePosition(OP_BUY);   
      if(OrdersTotal()==0){
         flag=1;
         accountProfit = trailing_start;
      }
      if(OrdersTotal()==0){
         Print("开始卖出");
         int order = OrderSend(NULL,OP_SELL,order_volumn,Bid,0,0,0);
         printError("卖出"+Symbol(),order);
      }
   }
   if(AccountProfit()<(0-max_stopless)||AccountProfit()>max_profit){
      ClosePosition(OP_BUY);
      ClosePosition(OP_SELL);
      flag=1;
      accountProfit = trailing_start;
   }
   Comment("\n\n当前账户盈利："+AccountProfit()+"，flag："+flag+"，开仓数："+order_volumn);
   if(AccountProfit()>(((flag*flag-flag+2)/2)*add_profit)&&AccountBalance()>2000){
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
   if(accountProfit>=AccountProfit()&&AccountProfit()>trailing_start){
      Print("当前盈利："+AccountProfit()+"，开始平仓");
      ClosePosition(OP_BUY);
      ClosePosition(OP_SELL);
   }
   if(accountProfit<AccountProfit()*(1-Percent)){
      accountProfit = AccountProfit()*(1-Percent);
      Print("追踪止盈上调至:"+accountProfit);
   }
   
}


