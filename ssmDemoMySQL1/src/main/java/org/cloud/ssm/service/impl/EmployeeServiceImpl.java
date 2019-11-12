package org.cloud.ssm.service.impl;

import java.util.List;

import org.cloud.ssm.entity.Employee;
import org.cloud.ssm.mapper.EmployeeMapper;
import org.cloud.ssm.service.EmployeeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.github.pagehelper.PageHelper;

@Service
public class EmployeeServiceImpl implements EmployeeService {

    @Autowired
    private EmployeeMapper employeeMapper;

    @Override
    public void addEmployee(Employee employee) {
        employeeMapper.addEmployee(employee);
    }

    @Override
    public List<Employee> listEmployee() {
        return employeeMapper.listEmployee();
    }

    @Override
    public void deleteEmployee(long employeeID) {
        employeeMapper.deleteEmployee(employeeID);
    }

	@Override
	public Employee getEmployee(long employeeID) {
		return employeeMapper.getEmployee(employeeID);
	}

	@Override
	public void updateEmployee(Employee employee) {
		employeeMapper.updateEmployee(employee);
	}

	@Override
	public List<Employee> getAllByPage(int pageNum, int pageSize) {
		PageHelper.startPage(pageNum, pageSize);
		return employeeMapper.listEmployee();
	}

	@Override
	public long getCount() {
		return employeeMapper.getCount();
	}

}
