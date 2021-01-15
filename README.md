# Tetris 
## A Tetris Battle Game on FPGA
- Language : SystemVerilog
- Development Environment : Quartus 13.1

## User Interface
- 4 bit button input : 左右移動、旋轉方塊、加快下落速度
- 8X8 RGB 顯示遊戲畫面
- LED 消去行數進度條
- 七段顯示器顯示等級
- lcd 顯示固定文字標題

## 程式模組說明
```
module lab22(//input Count,
output reg [7:0] DATA_R, DATA_G, DATA_B,       // 分別接到 8*8 led matrix 上的 CR_{1...8}, CG_{1...8}, CB_{1...8}
			output reg [2:0] COMM,                                              //  接到 8* 8 led matrix 上的 s{1...3} 
      output reg [2:0] s = 3'b000,                                        // 測試當前block世哪個（don't care）
			output reg [2:0] s4 = 3'b000,                                     // 測試當前block世哪個（don't care）
			input left, right, change, down,                              // 接到 4 個 button
			output enable,                                                               // 8*8 led natrix 的 enable
			output IH,                                                                          // (don't care）
			output testled,                                                               // test(don't care)
			output reg [0:7] level = 8'b00000000,                 // 當前等機消掉的 row 數
			output reg [0:6] z = 7'b0000001,                            // 等級以七段顯示器顯示（level_n -> z）
			input CLK,                                                                        // 22_PIN
			input		reg	rst_n,                                                            // 偵測到 negetage 就會 重製 lcd 顯示
			output	reg			lcd_rs,                                                   // 接到 lcd 的 r/s
			output		lcd_rw,                                                          // 接到 lcd 的 r/w
			output	reg			lcd_en,                                               // 接到 lcd 的 e
			output	reg	[7:0]	lcd_data	                                    // 接到 lcd 的 data input
			);
```
## 基本功能
- 隨機出現一種方塊
- 碰到底部或堆疊的方塊會停止 
- 下落中的方塊可左右移動、轉向、加速 
- 橫排填滿時會消掉，上面方塊向下填補 
- 堆疊方塊碰到頂部的時候結束遊戲
- 方塊下降速度隨著等級上升變快
- 每消兩行就會晉級
- 方塊擋到最上面且最中間的位置時遊戲結束

## 進階功能
- 可踢轉
- 進度條滿時晉級
- 方塊落下速度隨等級增加
- Game Over 時顯示 windows :( 表情

## 增加功能
  - 笑臉轉向
  - 第一關通過時會有：）

## demo 影片
<a href="https://drive.google.com/file/d/1v1BZ9V3-ugrf0mjXll1PbCfDZRPeoyCk/view?usp=sharing" title="Demo Video"><img src="https://raw.githubusercontent.com/efficacy38/Tetris/master/img/2021-01-15%2015-33-03%20%E7%9A%84%E8%9E%A2%E5%B9%95%E6%93%B7%E5%9C%96.jpg" alt="Demo Video" width="500"/></a>
