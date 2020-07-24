clc; clear;
% 第一问代码 文件名：qus1.m
filename = 'C:\Users\ygx79\Desktop\附件1\*.bmp'
files = dir(filename);    %批量载入图像
image = cell(1, size(files, 1)) ;  % 定义一个元组

for n=1:numel(files)
 image{n} = imread(['C:\Users\ygx79\Desktop\附件1\', files(n).name]);
end

[rol,col] = size(image{1,1});            % 计算一张图片矩阵的大小(行，列)

% 只取最左和最右列进行灰色关联分析
% left 存放 n 张图片的，最左列 (1980行, n列)
for k=1:n
   left(:, k) = image{1, k}(: , 1);      % 将第k张图片的最左边一列放入矩阵left的第k列                     
   right(:, k) = image{1, k}(: , col);      % 将第k张图片的最右边一列放入矩阵right的第k列
end

%利用页边距寻找第一张图片
for i=1:n                                     % 遍历附件1的所有图片 
    sum=0;
    for j=1:rol                                 % 遍历 图片最左列 的所有行
        if left(j,i) == 255                 % 计算255的个数 
            sum=sum+1;
        else
            break;
        end
    end
    if sum==rol                             % 如果 最左列255个数和行数一样，说明他属于第一张图片
        f=i;
    end
end

sequence=zeros(1,n);                       % 定义 n列向量，用来排序
index=1;
sequence(index) = f;                        % 选择第一张图片
i = f;

relevancy = ones(n, 1);
rho = 0.45;            % 分辨系数

while index <= n - 1
        op_tmp = right(:, i);
        left(:, i)= nan;
        t = repmat(op_tmp, [1, n]) - left(:,:) ;
        mmin = min(min(t));
        mmax = max(max(t));
        alpha = (mmin + rho .* mmax) ./ (t +rho .* mmax);
        relevancy = mean(alpha);
        [gsort, ind] = sort(relevancy, 'descend');
        i = ind(1);
        index = index + 1;
        sequence(index) = i;
end
        

% 通过 系数的排序进行合成图片，在此之前，无论用什么方法，只需要求出关于关联系数的排序就好了
temp = image{ sequence(1) };
for i=2:n
    temp=[temp image{ sequence(i)} ];       %将排序好的图片存放与temp       
end

imshow(temp)                                    %完整显示整张纸片
%imsave(temp,"C:xxx")