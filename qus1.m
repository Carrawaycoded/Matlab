clc; clear;
% ��һ�ʴ��� �ļ�����qus1.m
filename = 'C:\Users\ygx79\Desktop\����1\*.bmp'
files = dir(filename);    %��������ͼ��
image = cell(1, size(files, 1)) ;  % ����һ��Ԫ��

for n=1:numel(files)
 image{n} = imread(['C:\Users\ygx79\Desktop\����1\', files(n).name]);
end

[rol,col] = size(image{1,1});            % ����һ��ͼƬ����Ĵ�С(�У���)

% ֻȡ����������н��л�ɫ��������
% left ��� n ��ͼƬ�ģ������� (1980��, n��)
for k=1:n
   left(:, k) = image{1, k}(: , 1);      % ����k��ͼƬ�������һ�з������left�ĵ�k��                     
   right(:, k) = image{1, k}(: , col);      % ����k��ͼƬ�����ұ�һ�з������right�ĵ�k��
end

%����ҳ�߾�Ѱ�ҵ�һ��ͼƬ
for i=1:n                                     % ��������1������ͼƬ 
    sum=0;
    for j=1:rol                                 % ���� ͼƬ������ ��������
        if left(j,i) == 255                 % ����255�ĸ��� 
            sum=sum+1;
        else
            break;
        end
    end
    if sum==rol                             % ��� ������255����������һ����˵�������ڵ�һ��ͼƬ
        f=i;
    end
end

sequence=zeros(1,n);                       % ���� n����������������
index=1;
sequence(index) = f;                        % ѡ���һ��ͼƬ
i = f;

relevancy = ones(n, 1);
rho = 0.45;            % �ֱ�ϵ��

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
        

% ͨ�� ϵ����������кϳ�ͼƬ���ڴ�֮ǰ��������ʲô������ֻ��Ҫ������ڹ���ϵ��������ͺ���
temp = image{ sequence(1) };
for i=2:n
    temp=[temp image{ sequence(i)} ];       %������õ�ͼƬ�����temp       
end

imshow(temp)                                    %������ʾ����ֽƬ
%imsave(temp,"C:xxx")