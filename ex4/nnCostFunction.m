function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%



% --- Part 1 ---

% for i=1:m
%   y_all(:,i) = ((1:num_labels)'==y(i));     %10x5000
% end

y_all = (1:num_labels == y); %5000x10

X = [ones(m,1) X];  %5000x401
z2 = X*Theta1';     %5000x25
a2 = sigmoid(z2);   %5000x25
a2_new = [ones(size(a2,1),1) a2];   %5000x26

z3 = a2_new*Theta2';    %5000x10
a3 = sigmoid(z3);       %5000x10

[~,I] = max(a3, [], 2);
p = I(:);       %5000x1

% for i=1:m
%    J(i) = (1/m)*(log(a3(i,:))*(-y_all(:,i)) - log(1-a3(i,:))*(1-y_all(:,i)));
% end
%     J = sum(J);     %J <- 5000x1
  
    J = (1/m)*sum(sum((log(a3).* (-y_all) - log(1-a3) .* (1-y_all))));
    
% --- Part 2 ---
D_1 = zeros(size(Theta1));      %25x401
D_2 = zeros(size(Theta2));      %10x26

d3 = a3 - y_all;     %5000*10
d2 = (d3 * Theta2(:,2:end)) .* (a2.*(1-a2));    %5000x25 a2 자체가 1을 추가하기 전의 행렬이어서 1열에 대한 계산 제거해준다. 시그모이드 미분한게 그러니까 a에 맞추자.
D_1 = D_1 + (d2' * X);          %25x401
D_2 = D_2 + (d3' * a2_new);     %10x26
 
Theta1_grad = (1/m)*(D_1);      %25x401
Theta2_grad = (1/m)*(D_2);      %10x26



% --- Part 3 ---
Theta1(:,1) = 0;
Theta2(:,1) = 0;

J = J + (lambda/(2*m))*(sum(sum(Theta1.^2))+sum(sum(Theta2.^2)));

Theta1_grad = Theta1_grad + (lambda/m)*(Theta1);
Theta2_grad = Theta2_grad + (lambda/m)*(Theta2); 

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
