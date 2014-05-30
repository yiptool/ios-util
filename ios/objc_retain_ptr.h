/* vim: set ai noet ts=4 sw=4 tw=115: */
//
// Copyright (c) 2014 Nikolay Zapolnov (zapolnov@gmail.com).
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
#import <UIKit/UIKit.h>

/**
 * Smart pointer for Objective-C objects using the retain/release semantic.
 * @tparam TYPE Objective-C class.
 */
template <class TYPE> class ObjCRetainPtr
{
public:
	/** Constructor. */
	inline ObjCRetainPtr()
		: m_Object(nil)
	{
	}

	/**
	 * Constructor.
	 * @param obj Pointer to the object.
	 */
	inline ObjCRetainPtr(TYPE * obj)
		: m_Object([obj retain])
	{
	}

	/**
	 * Copy constructor.
	 * @param src Reference to the source object.
	 */
	inline ObjCRetainPtr(const ObjCRetainPtr & src)
		: m_Object([src.m_Object retain])
	{
	}

	/** Destructor. */
	inline ~ObjCRetainPtr()
	{
		[m_Object release];
	}

	/**
	 * Assignment operator.
	 * @param src Reference to the source object.
	 * @return Reference to `this`.
	 */
	inline ObjCRetainPtr & operator=(const ObjCRetainPtr & src)
	{
		[m_Object release];
		m_Object = nil;
		m_Object = [src.m_Object retain];
		return *this;
	}

	/**
	 * Retrieves pointer to the Objective-C object.
	 * @return Pointer to the Objective-C object.
	 */
	inline operator TYPE * () const
	{
		return m_Object;
	}

	/**
	 * Retrieves pointer to the Objective-C object.
	 * @return Pointer to the Objective-C object.
	 */
	inline TYPE * operator->() const
	{
		return m_Object;
	}

	/**
	 * Retrieves pointer to the Objective-C object.
	 * @return Pointer to the Objective-C object.
	 */
	inline TYPE * id() const
	{
		return m_Object;
	}

private:
	TYPE * m_Object;
};
