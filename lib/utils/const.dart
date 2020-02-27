import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(18, 99, 129, 1);
const indicatorHome = Color.fromRGBO(18, 134, 152, 1);
const primaryColorHome = Color.fromRGBO(57, 69, 83, 1);
const secondColorHome = Color.fromRGBO(92, 109, 129, 1);

const statusMapping = {
  "": "Không xác định",
  "picking": "Đang lấy hàng",
  "picking1": "Lấy hàng lần 1",
  "picking2": "Lấy hàng lần 2",
  "picking3": "Lấy hàng lần 3",
  "picked": "Lấy hàng thành công",
  "picking_fail": "Không lấy được hàng sau 3 lần",
  "picking_fail_by_shoping": "Shop từ chối giao hàng",
  "returning_driver": "Trả hàng",
  "returning1": "Trả hàng lần 1",
  "returning2": "Trả hàng lần 2",
  "returning3": "Trả hàng lần 3",
  "return_fail": "Không trả được hàng sau 3 lần",
  "returned": "Trả hàng thành công",
  "return_fail_by_shop": "Shop từ chối nhận hàng",
  "cancel_by_branch": "Đối tác hủy",
  "cancel_by_shop": "Shop hủy",
  "new": "Mới",
  "delived": "Rider bàn giao thành công",
  "delived_to_sort": "Giao hàng cho sort",
  "delived_to_sort_done": "Bàn giao cho sort thành công",
  "returning": "Trả hàng",
  "returning_from_sort": "Lấy hàng tại sort thành công",
  "returning_from_hub": "Bàn giao tại hub thành công",
  "returning_from_driver": "Bàn giao cho rider thành công",
};
