function self = egg(self, varargin)

if length(varargin) == 1
    author = varargin{1};
else
    author = [];
end

% Offset
nameOffsetX = 0.5;
nameOffsetY = 0.11;
textOffsetX = 0.45;
textOffsetY = 0.22;

xName = self.windowWidth*nameOffsetX;
yName = self.windowHeight*nameOffsetY;

xText = self.windowWidth*textOffsetX;
yText = self.windowHeight*textOffsetY;

% The text I want to display
displayName=' eanicSirirantrvoC';
shuffleName=[  9, 17,  2, 16, 13, 11, 10, 15,  4,  5, 12,  8,  7,  3, 18, 14,  6,  1];
displayText=[...
    ' e e         a y dw a  d u   fcsi io  ';...
    ' en cl  rt  e y it   ob fea S in g P  ';...
    '  :  t eg bd  . kx lSsa h      e a  o ';...
    ' :   u     tdsy     sg   d  ohn ?  t e';...
    '    y"u  g  u fs  h     easatv  d ei( ';...
    '  t, )  e    y   ho nTI    fIs  l t   ';...
    ')i  ktro l   f o o  yr a drer      i  ';...
    'rn .l o  a t  roli    n tosoi d hol   ';...
    '   aelo a  to r o    oe eMds m     o  ';...
    'cea     n     -      cy n   nd     h  ';...
    's  e   c       kt  S oP ap  i      r  ';...
    'ost     o''eatao   uoht a e y  t. kt   ';...
    '  "v r p     le  sdea   e  nue   ld p ';...
    '    e r fyo.    o  l   e  wo  e    Cu ';...
    'ei w esn a      n  f ke oi       u    ';...
    ' t esdr j     aige                    '];
shuffleText=[...
    574, 165, 564, 447, 366, 144, 315, 350, 544, 594, 362, 324,  16, 416,  52, 231, 101, 406, 519, 595,  56, 548, 347, 533, 148, 257,  28, 554,  64,  22, 453, 376,  18, 484, 434, 262, 485, 460;...
    473, 322, 307, 141, 389,   2, 462,  91, 481, 424, 474, 330, 337, 264, 329, 100, 275,  50, 567,  27, 333, 336,   8,  77, 463, 193, 179, 346,   5, 476, 133, 450, 591, 386, 109, 185, 234, 408;...
    112,  31, 355, 442, 281,  34, 250, 384, 147, 499, 368, 551, 580, 435, 409, 124, 177,  92, 159, 145, 191, 113, 243, 238, 130, 152, 204,  57, 415, 452,  45,  51, 427, 103, 523, 332, 115,  95;...
    183, 207, 398, 524, 220, 374, 583, 308, 522, 206, 555, 259, 178, 176,  54,  72, 187,  10, 582, 444, 290,   7, 334, 196, 122, 168,  44, 190,  65, 255, 131, 429,  41,  42,  20, 470, 483, 293;...
    75, 566, 229, 553, 438, 226,   9, 426, 276, 402, 531, 436, 211, 570, 280, 297, 284, 605, 289, 140, 521,  33, 577,  90, 497, 295,  25,  76, 358, 449, 466, 364, 369, 387, 136, 146, 169, 316;...
    413, 267, 343, 407, 525, 457, 556, 587, 512, 351, 301, 579, 604, 361, 430,  43, 607, 440, 552, 394,  88, 239,   1,  36, 106, 132, 300, 182,  53, 401, 600,  93, 227, 502,  17, 589, 142, 354;...
    371,   6, 500, 352, 277, 325, 134, 480, 107,  66, 541, 202,  32, 439, 584, 135, 381, 291, 490, 526, 225, 528, 129, 422, 126,  35, 390, 230, 163, 348, 156, 572, 493, 388, 345, 161, 299, 451;...
    263, 151, 586, 441, 487, 286, 241, 160, 237, 233, 251, 306, 304, 472, 198, 534, 117, 385, 411, 302, 529, 495, 200, 428, 367,  21, 256, 213, 104, 419, 199, 252, 383,  70, 431, 205, 478, 331;...
    559, 244, 339, 421, 265, 464, 296, 166, 501, 260, 373, 195,  55, 254, 359,  68, 520, 596, 491, 356, 412, 240, 377, 314, 370,  60, 513, 249,  98, 545, 423, 599, 128,  40,  94, 335,  96, 309;...
    120, 194, 313, 536, 266, 403,  80, 125, 517, 550, 601,  59, 468, 212, 327, 105, 560, 116, 349, 510, 219, 417,  24,  63, 210,  58,  89, 537, 216, 311,  11,  29, 298, 180,  39, 405,  62, 378;...
    527, 608,  84,  82, 397, 395, 418,   3, 127, 317,  74, 102, 173, 222, 270,  97, 197, 461, 606, 326, 189,  19, 175, 539, 215, 208, 588, 236, 511, 181,  78, 532, 155, 573, 353, 248, 598, 223;...
    503, 581, 488, 154, 253, 509, 515, 546, 486,  69, 167, 274, 319, 342, 498, 585, 203,  13, 192, 279, 341, 245, 246, 261, 540, 465, 459, 561, 410, 404, 320,  67, 269, 597, 479, 363, 571, 492;...
    508, 538, 114, 321, 380, 530, 282, 391, 454, 494, 119, 507, 516, 201, 232,  47, 443, 323, 288, 294, 118, 475, 445, 576, 456,  38, 328,  71, 360, 535, 164, 292, 285,  49,  85, 170, 224, 283;...
    218, 247, 123, 172, 258, 372, 312, 303, 448, 482, 433, 425,  15, 489, 414, 575,  23, 432, 111, 471, 382, 578,   4, 399, 446,  37, 504, 455, 458,  14, 214, 268, 121, 506, 318,  99,  86,  48;...
    217, 375, 379, 496, 143, 272, 287, 437, 603, 565,  46, 242,  12, 171, 542, 110, 278, 209, 602, 568, 569, 149, 357, 158,  81, 184, 592, 505, 139, 549, 188, 396, 593, 514, 365, 273, 547,  79;...
    221, 392, 137, 469, 393, 162, 338,  73, 344, 310, 590, 563,  61,  87, 305, 271, 518, 150,  26,  30, 543,  83, 108, 558, 186, 228, 400, 138, 340, 467, 174, 153, 477, 557, 157, 420, 562, 235];

if strcmpi(author, 'Max')
    displayName(shuffleName) = displayName;
    displayText(shuffleText) = displayText;
end

% Reduce the text size slightly and draw the name
Screen('TextSize', self.window, 42);
Screen('DrawText', self.window, displayName, xName, yName);

% Recude size even further and draw the text
Screen('TextSize', self.window, 34);
for i = 1:size(displayText,1)
    Screen('DrawText', self.window, displayText(i,:), xText, yText+(i-1)*42);
end

% Reset the text size to default
Screen('TextSize', self.window, 50);

% Start the flower

flowerBottomY = 0.95;
stemWidth = 10;

% Flower's stem
stemX = self.windowWidth/4;
stemColour = [122/255, 223/255, 89/255];

stem = [...
    stemX self.windowHeight*flowerBottomY; ...
    stemX self.windowYCentre];
Screen('DrawLines', self.window, stem', stemWidth, ...
    stemColour, [0 0], 0);

for i = 1:10
    %
    grassBaseRect = [0 0 45+10*rand() 40+30*rand()];
    offset = 20*rand();
    
    % Draw grass towards the right
    grassRect = CenterRectOnPoint(...
        grassBaseRect, ...
        stemX+grassBaseRect(3)/2+offset, ...
        self.windowHeight*flowerBottomY);
    grassColour = stemColour + [0 (rand()-0.5)*0.5 0];
    grassColour = max(min(grassColour, [1 1 1]), [0 0 0]);
    Screen('FrameArc', self.window, ...
        grassColour, grassRect, -90, 40+20*rand(), 2, 2);
    
    % Draw grass towards the left
    grassRect = CenterRectOnPoint(...
        grassBaseRect, ...
        stemX-grassBaseRect(3)/2-offset, ...
        self.windowHeight*flowerBottomY);
    grassColour = stemColour + [0 (rand()-0.5)*0.5 0];
    grassColour = max(min(grassColour, 1), 0);
    Screen('FrameArc', self.window, ...
        grassColour, grassRect, 90, -40-20*rand(), 2, 2);
end

% Draw the earth

earthColour = [71/255; 28/255; 1/255; 1];
earthCoords = nan(2,1000);
earthCoords(1,:) = normrnd(stemX, 60, ...
    1, size(earthCoords,2));
earthCoords(2,:) = self.windowHeight*flowerBottomY + ...
    abs(normrnd(0, 10, 1, size(earthCoords,2)));
earthColour = repmat(earthColour, 1, size(earthCoords,2)) + ...
    [(rand(1,size(earthCoords,2))-0.5)*0.2; ...
    (rand(1,size(earthCoords,2))-0.5)*0.15; ...
    (rand(1,size(earthCoords,2))-0.5)*0.05; ...
    zeros(1,size(earthCoords,2))];
earthColour = max(min(earthColour, 1), 0);
Screen('DrawDots', self.window, earthCoords, 7, earthColour, [0 0], 1);

% Draw a leaf

leafBaseRect = [0 0 self.windowWidth/10 self.windowWidth/32];
leafRect = CenterRectOnPoint(leafBaseRect, 0, 0);

rotation = -rand()*25;
Screen('glTranslate', self.window, stemX+leafBaseRect(3)/2, self.windowHeight*0.66);
Screen('glRotate', self.window, rotation);
Screen('FillOval', self.window, stemColour + [0 -rand()*0.2 0], leafRect);
edgeColour = stemColour + [0 rand()*0.5 0];
Screen('FrameOval', self.window, edgeColour, leafRect, 2, 2);
Screen('DrawLine', self.window, edgeColour, leafRect(1)+10, 0, leafRect(3)-10, 0, 2);
Screen('glRotate', self.window, -rotation);
Screen('glTranslate', self.window, -stemX-leafBaseRect(3)/2, -self.windowHeight*0.66);


% Draw the flowe centre

% Make the core
edgeColour = [252/255, 145/255, 58/255] + (rand()-0.5)*0.1;
edgeColour = max(min(edgeColour, 1), 0);
coreColour = [249/255, 212/255, 35/255] + (rand()-0.5)*0.1;
coreColour = max(min(coreColour, 1), 0);
flowerBaseCore = [0 0 self.windowWidth/8 self.windowWidth/6];
flowerCore = CenterRectOnPoint(flowerBaseCore, ...
    self.windowWidth/4, self.windowYCentre-flowerBaseCore(4)/2);
Screen('FillOval', self.window, coreColour, flowerCore);
Screen('FrameOval', self.window, edgeColour, flowerCore, 5, 5);

% Add colour
flowerColour = [255/255, 78/255, 80/255];
teeth = randi(3)*2;

toothSpaceX = flowerBaseCore(3)+20;
toothSpaceY = rand()*15+10;
toothCentreY = self.windowYCentre-flowerBaseCore(4)/2-20;

flowerPoints = nan(teeth*2+1,2);

for i = 1:size(flowerPoints, 1)
    offset = i-teeth-1;
    
    flowerPoints(i,1) = stemX+(offset*toothSpaceX/(2*teeth));
    if mod(offset,2) == 0
        flowerPoints(i,2) = toothCentreY-toothSpaceY;
    else
        flowerPoints(i,2) = toothCentreY+toothSpaceY;
    end
end

if mod(teeth, 2) == 0
    flowerPoints = [...
        flowerPoints(1,1) toothCentreY+toothSpaceY; ...
        flowerPoints; ...
        flowerPoints(end,1) toothCentreY+toothSpaceY];
end

Screen('FillPoly', self.window, flowerColour, flowerPoints, 0);

bottomBaseCore = [0 0 toothSpaceX self.windowWidth/6+toothSpaceY+2];
bottomCore = CenterRectOnPoint(bottomBaseCore, ...
    self.windowWidth/4, toothCentreY+toothSpaceY-1);
Screen('FillArc', self.window, flowerColour, bottomCore, 90, 180);

% Print everything on screen
self = self.flip();
KbWait();

% Reset to default text size
Screen('TextSize', self.window, 50);
end