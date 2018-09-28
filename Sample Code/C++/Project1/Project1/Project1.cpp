// Project1.cpp : ����Ӧ�ó������ڵ㡣
//

#include "stdafx.h"
#include "Project1.h"
#include<math.h>

#define MAX_LOADSTRING 100
#define Pi 3.1415926

// ȫ�ֱ���: 
HINSTANCE hInst;								// ��ǰʵ��
TCHAR szTitle[MAX_LOADSTRING];					// �������ı�
TCHAR szWindowClass[MAX_LOADSTRING];			// ����������

// �˴���ģ���а����ĺ�����ǰ������: 
ATOM				MyRegisterClass(HINSTANCE hInstance);
BOOL				InitInstance(HINSTANCE, int);
LRESULT CALLBACK	WndProc(HWND, UINT, WPARAM, LPARAM);
INT_PTR CALLBACK	About(HWND, UINT, WPARAM, LPARAM);

int APIENTRY _tWinMain(_In_ HINSTANCE hInstance,
                     _In_opt_ HINSTANCE hPrevInstance,
                     _In_ LPTSTR    lpCmdLine,
                     _In_ int       nCmdShow)
{
	UNREFERENCED_PARAMETER(hPrevInstance);
	UNREFERENCED_PARAMETER(lpCmdLine);

 	// TODO:  �ڴ˷��ô��롣
	MSG msg;
	HACCEL hAccelTable;

	// ��ʼ��ȫ���ַ���
	LoadString(hInstance, IDS_APP_TITLE, szTitle, MAX_LOADSTRING);
	LoadString(hInstance, IDC_PROJECT1, szWindowClass, MAX_LOADSTRING);
	MyRegisterClass(hInstance);

	// ִ��Ӧ�ó����ʼ��: 
	if (!InitInstance (hInstance, nCmdShow))
	{
		return FALSE;
	}

	hAccelTable = LoadAccelerators(hInstance, MAKEINTRESOURCE(IDC_PROJECT1));

	// ����Ϣѭ��: 
	while (GetMessage(&msg, NULL, 0, 0))
	{
		if (!TranslateAccelerator(msg.hwnd, hAccelTable, &msg))
		{
			TranslateMessage(&msg);
			DispatchMessage(&msg);
		}
	}

	return (int) msg.wParam;
}



//
//  ����:  MyRegisterClass()
//
//  Ŀ��:  ע�ᴰ���ࡣ
//
ATOM MyRegisterClass(HINSTANCE hInstance)
{
	WNDCLASSEX wcex;

	wcex.cbSize = sizeof(WNDCLASSEX);

	wcex.style			= CS_HREDRAW | CS_VREDRAW;
	wcex.lpfnWndProc	= WndProc;
	wcex.cbClsExtra		= 0;
	wcex.cbWndExtra		= 0;
	wcex.hInstance		= hInstance;
	wcex.hIcon			= LoadIcon(hInstance, MAKEINTRESOURCE(IDI_PROJECT1));
	wcex.hCursor		= LoadCursor(NULL, IDC_ARROW);
	wcex.hbrBackground	= (HBRUSH)(COLOR_WINDOW+1);
	wcex.lpszMenuName	= MAKEINTRESOURCE(IDC_PROJECT1);
	wcex.lpszClassName	= szWindowClass;
	wcex.hIconSm		= LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_SMALL));

	return RegisterClassEx(&wcex);
}

//
//   ����:  InitInstance(HINSTANCE, int)
//
//   Ŀ��:  ����ʵ�����������������
//
//   ע��: 
//
//        �ڴ˺����У�������ȫ�ֱ����б���ʵ�������
//        ��������ʾ�����򴰿ڡ�
//
BOOL InitInstance(HINSTANCE hInstance, int nCmdShow)
{
   HWND hWnd;

   hInst = hInstance; // ��ʵ������洢��ȫ�ֱ�����

   hWnd = CreateWindow(szWindowClass, szTitle, WS_OVERLAPPEDWINDOW,
      CW_USEDEFAULT, 0, CW_USEDEFAULT, 0, NULL, NULL, hInstance, NULL);

   if (!hWnd)
   {
      return FALSE;
   }

   ShowWindow(hWnd, nCmdShow);
   UpdateWindow(hWnd);

   return TRUE;
}

//
//  ����:  WndProc(HWND, UINT, WPARAM, LPARAM)
//
//  Ŀ��:    ���������ڵ���Ϣ��
//
//  WM_COMMAND	- ����Ӧ�ó���˵�
//  WM_PAINT	- ����������
//  WM_DESTROY	- �����˳���Ϣ������
//
//
LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int wmId, wmEvent;
	PAINTSTRUCT ps;
	HDC hdc;
	HPEN hpen;
	HBRUSH hbrush;
	POINT pts[6];
	pts[1].y = pts[0].x = pts[0].y = 100;
	pts[1].x = 200;
	pts[2].x = 200 + 100 * sin(18 * Pi / 180);
	pts[4].y = pts[2].y = 100 + 100 * cos(18 * Pi / 180);
	pts[3].x = 150;
	pts[3].y = pts[2].y + 100 * cos(54 * Pi / 180);
	pts[4].x = 100 - 100 * sin(18 * Pi / 180);
	pts[5] = pts[0];
	POINT ptss[5];
	ptss[0].x = 150;
	ptss[0].y = 100 + 50 * (pts[2].y - 100) / (pts[2].x - 100);
	ptss[1].x = pts[0].x + pts[2].x - ptss[0].x;
	ptss[1].y = pts[0].y + pts[2].y - ptss[0].y;
	ptss[2].x = pts[1].x + pts[3].x - ptss[1].x;
	ptss[2].y = pts[1].y + pts[3].y - ptss[1].y;
	ptss[3].y = ptss[2].y;
	ptss[3].x = 300 - ptss[2].x;
	ptss[4].x = 300 - ptss[1].x;
	ptss[4].y = ptss[1].y;
	POINT pt[5];

	switch (message)
	{
	case WM_COMMAND:
		wmId    = LOWORD(wParam);
		wmEvent = HIWORD(wParam);
		// �����˵�ѡ��: 
		switch (wmId)
		{
		case IDM_ABOUT:
			DialogBox(hInst, MAKEINTRESOURCE(IDD_ABOUTBOX), hWnd, About);
			break;
		case IDM_EXIT:
			DestroyWindow(hWnd);
			break;
		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
		}
		break;
	case WM_PAINT:
		hdc = BeginPaint(hWnd, &ps);
		hpen = CreatePen(PS_SOLID, 0, RGB(255, 0, 0));
		SetMapMode(hdc, MM_TEXT);
		SelectObject(hdc, hpen);
		Polygon(hdc, pts, 6);
		for (int i = 0; i < 5; i++)
		{
			hpen = CreatePen(PS_SOLID, 0, RGB(0, 255 - 50 * i, 50 * i));
			SelectObject(hdc, hpen);
			pt[0] = pts[i];
			pt[1] = pts[(i + 2) % 5];
			Polyline(hdc, pt, 2);
		}
		hbrush = (HBRUSH)GetStockObject(GRAY_BRUSH);
		SelectObject(hdc, hbrush);
		Polygon(hdc, ptss, 5);
		hbrush = CreateSolidBrush(RGB(0, 0, 255));
		SelectObject(hdc, hbrush);
		for (int k = 0; k < 5; k++)
		{
			pt[0] = pts[k];
			pt[1] = pts[k + 1];
			pt[2] = ptss[k];
			Polygon(hdc, pt, 3);
		}
		hbrush = CreateSolidBrush(RGB(50, 200, 0));
		SelectObject(hdc, hbrush);
		for (int m = 0; m < 5; m++)
		{
			pt[0] = pts[m];
			pt[1] = ptss[m];
			pt[2] = ptss[(m + 4) % 5];
			Polygon(hdc, pt, 3);
		}

		DeleteObject(hpen);
		DeleteObject(hbrush);
		// TODO:  �ڴ���������ͼ����...
		EndPaint(hWnd, &ps);
		break;
	case WM_DESTROY:
		PostQuitMessage(0);
		break;
	default:
		return DefWindowProc(hWnd, message, wParam, lParam);
	}
	return 0;
}

// �����ڡ������Ϣ�������
INT_PTR CALLBACK About(HWND hDlg, UINT message, WPARAM wParam, LPARAM lParam)
{
	UNREFERENCED_PARAMETER(lParam);
	switch (message)
	{
	case WM_INITDIALOG:
		return (INT_PTR)TRUE;

	case WM_COMMAND:
		if (LOWORD(wParam) == IDOK || LOWORD(wParam) == IDCANCEL)
		{
			EndDialog(hDlg, LOWORD(wParam));
			return (INT_PTR)TRUE;
		}
		break;
	}
	return (INT_PTR)FALSE;
}
