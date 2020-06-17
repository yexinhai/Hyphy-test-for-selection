# Xinhai Ye, yexinhai@zju.edu.cn
find ./single_copy_5047*/hyphy_result -name "*.busted.result" -exec bash -c 'cat $0 >>busted.all; echo >>busted.all' {} \;
