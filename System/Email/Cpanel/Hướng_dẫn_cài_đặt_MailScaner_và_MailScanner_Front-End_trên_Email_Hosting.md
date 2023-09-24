# **Hướng dẫn cài đặt MailScanner và MailScanner Front-End trên Email Hosting WHM/Cpanel**


## **I. Các bước chuẩn bị**
> **Note:** Để xem chi tiết cài đặt từ trang chính thống các bạn có thể xem tại https://configserver.com/free-cpanel-mailscanner-installer/

### **1. Tắt chức năng Default Address**

Trong CPanel, chức năng "Default Address" (Địa chỉ mặc định) là một cài đặt cho tài khoản email của bạn, cho phép bạn quy định cách xử lý email gửi đến địa chỉ không tồn tại trong tài khoản email của bạn.

Khi một email được gửi đến một địa chỉ email không tồn tại trên máy chủ của bạn, chức năng "Default Address" cho phép bạn chọn một hành động cụ thể để xử lý email này. Có một số lựa chọn phổ biến bạn có thể chọn:

- Discard
- Forward to Email Address
- Forward to System Account
- Pipe to a Program

Nên tắt tính năng này để hạn chế rủi ro bảo mật
Thay vào đó nên cấu hình chỉ cho phép gửi mail đến các tài khoản thực sự tồn tại trong Cpanel.
Đều này sẽ kiểm tra RCPT ngay từ lúc đầu tiên trong quá trình gửi mail và từ chối nếu RCPT không tồn tại hoặc không hợp lệ

Để tắt tính năng này, cá bạn thực hiện theo các bước sau:

```bash
WHM > Server Configuration > Tweak Settings > Initial default/catch-all forwarder destination` và tích chọn vào `Fail > Save
```


```bash
#Backup lại thư mục /etc/valiases và chạy đoạn code sau để cấu hình thông báo lỗi khi RCPT không tồn tại
cp -R /etc/valiases /etc/valiases.bak130923
for i in `ls /var/cpanel/users/`;do replace "*: $i" "*: :fail: No Such User Here" -- /etc/valiases/*;done
```

```bash
WHM > Packages > Feature Manager > Feature Lists > chọn list tương ứng  Edit Bỏ tích chọn "Default Address", "Apache SpamAssassin", "Apache SpamAssassin™ Spam Box"  và Save lại 
```

```bash
WHM > Tweak Settings > Bỏ tích chọn "Enable Apache SpamAssassin™ spam filter" và "Apache SpamAssassin Spam Box"
```

``` bash
WHM > Service Manager > Bỏ tích chọn cả hai ô "Apache SpamAssassin" and click "Save"
```

## **II. Cài đặt MailScanner**
1. Download và cài đặt
```bash
cp /etc/exim.conf /etc/exim.conf.bak
chattr -i /etc/exim.conf 
cd /usr/src
rm -fv msinstall*
wget https://download.configserver.com/msinstall.tar.gz
tar -xzf msinstall.tar.gz
cd msinstall/
sh install.sh
/usr/mscpanel/mscheck.pl
/usr/msfe/msrules.pl -i
```
2. Chỉnh sửa file cấu hình sau khi cài đặt
```bash
#Bỏ dấu # hoặc thêm vào cuối file /etc/csf/csf.pignore
pcmd:MailScanner:.*
```
```bash
#Bỏ dòng sau trong /etc/exim.conf
queue_only_override = false 
```
3. Start và Enable MailScanner
```bash
systemctl start MailScanner
systemctl enable MailScanner
systemctl status MailScanner
systemctl restart lfd
```

## **III. Cài đặt MailScanner Front-End**
Để cài đặt bạn cần phải mua License với địa chỉ IP của server cần cài đặt
1. Cài đặt và cấu hình Razor and DCC
```bash
/usr/local/cpanel/3rdparty/perl/532/bin/razor-admin -create
/usr/local/cpanel/3rdparty/perl/532/bin/razor-admin -register
/usr/local/cpanel/3rdparty/perl/536/bin/razor-admin -create
/usr/local/cpanel/3rdparty/perl/536/bin/razor-admin -register

cd /usr/src/
wget https://www.dcc-servers.net/dcc/source/dcc.tar.Z
tar -xzf dcc.tar.Z
cd dcc-*/
./configure --disable-dccm
make
make install
sed -i "s/DCCM_LOGDIR=\"log\"/DCCM_LOGDIR=\"\"/" /var/dcc/dcc_conf
cdcc 'info -N'
cd ..
/bin/rm -Rf dcc-* dcc.tar.Z
```

2. Cấu hình mở port trong firewall

     - DCC - out-bound UDP port 6277 \
     - DCC - out-bound TCP port 587 \
     - Razor - out-bound TCP port 2703  

  
3. Download và cài đặt
```bash
cd /usr/src/
rm -fv msfe*
wget https://download.configserver.com/msfeinstaller.tgz
tar -xzf msfeinstaller.tgz
perl msfeinstaller.pl ipv4
rm -fv msfeinstaller.*
/usr/mscpanel/mscheck.pl
```
Nếu muốn cài đặt trên máy chủ khác phải thay đổi License\
https://license.configserver.com/cgi-bin/msfe/modify.cgi

4. Cấu hình MailScanner Configuration

Truy cập `WHM > ConfigServer MailScanner FE > MailScanner Configuration` và thực hiện theo các bước sau:

a. Đặt "Virus Scanners=" thành "clamd" nếu bạn đã cài đặt Clamav và muốn sử dụng daemon Clamd (được khuyến nghị) với MailScanner.

b. Tìm kiếm "Clamd Socket = " .Đảm bảo giá trị đó được đặt thành "/var/clamd" chứ KHÔNG phải "/tmp/clamd.socket".

c. Bạn cũng có thể muốn đặt "Spam List = " thành một trường trống nếu bạn đang sử dụng tính năng chặn RBL trong exim.

d. Đặt "%org-name%", "%org-long-name%" và "%web-site%" cho các cài đặt mong muốn. Đảm bảo %org-name% CHỈ bao gồm chữ và số ký tự, nghĩa là chỉ có chữ cái và số, KHÔNG có ký hiệu như _ hoặc - hoặc thậm chí là một tệp .

e. Nhấp vào "Change" ở dưới cùng khi bạn đã thực hiện tất cả các thay đổi ở trên.
