function Taylor0ton(Y, h, u, n, x0) %h������ �Լ�Y�� u�������� x = x0�϶�
                                    % 0���� n������ Taylor�޼�
syms x % ���� x�� ����
Y = subs(Y,h,x); %�Լ�Y���� h��� x�� ��ü(������ ��� ���ڵ� ������� ��)
i = 0; %ī���� i ����
t0 = subs(Y,x,x0);
while i <= n
T = Taylor(Y, x, u, i); % x�� �Ķ���ͷ� ���� 
                        % �Լ�Y�� 0�� ���������� Taylor�޼���
                        % i�������� ����.
T %ȭ�鿡 ���� i�� Taylor�޼��� ǥ��
t1 = subs(T, x, x0); %Taylor�޼��� x0�� �����Ͽ� ����� t1�� ����.
et = (t0 - t1); %�� ����� ������ ea ���.
fprintf(' => x = %f => %f, et = %f\n', x0, t1, et) %���
i = i+1; %ī��Ʈ
end
